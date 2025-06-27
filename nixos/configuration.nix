{ config
, lib
, pkgs
, inputs
, ...
}:

let
  extra-path = with pkgs; [
    dotnetCorePackages.sdk_8_0_3xx
    dotnetPackages.Nuget
    godot_4
    godot_4-export-templates
    mono
    msbuild
  ];
  extra-lib = [ ];
  rider = pkgs.jetbrains.rider.overrideAttrs (attrs: {
    postInstall =
      ''
        # Wrap rider with extra tools and libraries
        mv $out/bin/rider $out/bin/.rider-toolless
        makeWrapper $out/bin/.rider-toolless $out/bin/rider \
          --argv0 rider \
          --prefix PATH : "${lib.makeBinPath extra-path}" \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath extra-lib}"
      ''
      + (attrs.postInstall or "");
  });
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../modules/user.nix
    ../modules/containers/containers.nix
  ];

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_14;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.overlays = [(final: prev: {
    vo1ded-panel = inputs.vo1ded-panel.packages.x86_64-linux.default;
  })];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "filipnixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    keyMap = lib.mkForce "de";
    useXkbConfig = true;
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-sdk-6.0.428"
    "dotnet-runtime-6.0.36"
  ];

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="04e8", MODE="0666", GROUP="adbusers"
  '';

  services.xserver.enable = true;
    services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };
  # services.displayManager.sddm = {
  #  enable = true;
  #  wayland.enable = true;
  # };

  security.pam.services.gdm.enableGnomeKeyring = true;

  services.xserver.xkb.layout = "de";
  services.xserver.xkb.options = "eurosign:e,caps:escape";

  virtualisation.docker.enable = true;

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
  };

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    wireplumber.enable = true;
  };

  services.gvfs.enable = true;

  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [
    mesa
    mesa.drivers
  ];

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  user = {
    enable = true;
    username = "filip";
    sudoer = true;
    useHomeManager = true;
    homeManagerConfig = ../home-manager/home.nix;
  };

  containers-module.enable = true;

  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.pinentryPackage = pkgs.pinentry;

  services.pcscd.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    rider
    jetbrains.phpstorm
    jetbrains.idea-ultimate
    jetbrains.pycharm-professional
    jetbrains.datagrip
    jetbrains.rust-rover
    jetbrains.clion
    spotify
    steam
    protonplus
    xclicker
    gimp
    godot_4-mono
    libreoffice-qt6-still
    obs-studio
    smartmontools
    prismlauncher
    termscp
    telegram-desktop
    vesktop
    kalker
    teams-for-linux
    postman
    nodejs
    nodePackages_latest.pnpm
    pinentry
    remmina
    yubikey-manager
    yubikey-personalization
    yubikey-touch-detector
    docker
    vscode
    dbeaver-bin
    jdk8
    r2modman
    kitty
    hyprshot
    ags
    pciutils
    bun
    libgtop
    libnotify
    swww
    esbuild
    fish
    typescript
    dart-sass
    fd
    btop
    bluez
    gobject-introspection
    glib
    bluez-tools
    grimblast
    gpu-screen-recorder
    brightnessctl
    gnome-bluetooth
    python3
    matugen
    lutris
    wine
    gnome-keyring
    discord
    lsof
    switcheroo
    zed-editor
    nmon
    direnv
    adwsteamgtk
    zulu17
    gsettings-desktop-schemas
    obsidian
    devenv
    osslsigncode
  ] ++ [
    inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
  ];

  virtualisation.waydroid.enable = true;
  virtualisation.virtualbox.host = {
    enable = true;
    enableKvm = true;
    addNetworkInterface = false;
  };

  environment.sessionVariables = {
    GSETTINGS_SCHEMA_DIR = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas";
    GTK_THEME = "vo1ded-dark";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  programs.tmux = {
    enable = true;
    shortcut = "a";
  };

  programs.streamcontroller.enable = true;

  programs.nix-ld.enable = true;

  garuda.networking.iwd = false;
  garuda.performance-tweaks.enable = true;

  services.flatpak.enable = true;

  networking.firewall.enable = false;

  system.stateVersion = "24.05";
}
