# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

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

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "filipnixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    #font = "Lat2-Terminus16";
    keyMap = lib.mkForce "de";
    useXkbConfig = true; # use xkb.options in tty.k
  };

  nixpkgs.config.allowUnfree = true;

  # services.desktopManager.plasma6.enable = true;

  # Enable the X11   windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  # Configure keymap in X11
  services.xserver.xkb.layout = "de";
  services.xserver.xkb.options = "eurosign:e,caps:escape";

  virtualisation.docker.enable = true;
  
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
  };
  
  hardware.opengl = { # this fixes the "glXChooseVisual failed" bug, context: https://github.com/NixOS/nixpkgs/issues/47932 
    enable = true;
    driSupport32Bit = true; 
  }; 

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [
    mesa
    mesa.drivers
  ];
  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    open = false;
    # package = config.boot.kernelPackages.nvidiaPackages.stable;
    
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  user = {
    enable = true;
    username = "filip";
    sudoer = true;
    useHomeManager = true;
    homeManagerConfig = ../home-manager/home.nix;
  };
  
  containers-module.enable = true;
  
  #home-manager.users.filip = import ../home-manager/home.nix;

  #users.users.filip = {
  #  isNormalUser = true;
  #  extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #};
  
  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.pinentryPackage = pkgs.pinentry;
  
  services.pcscd.enable = true;
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    wget
    rider
    jetbrains.phpstorm
    jetbrains.idea-ultimate
    jetbrains.pycharm-professional
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
    dolphin
    konsole
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
  ];
  
  fonts.packages = with pkgs; [
    nerdfonts
  ];

  programs.tmux = {
    enable = true;
    shortcut = "a";
  };
  
  programs.streamcontroller.enable = true;

  # garuda.dr460nized.enable = true;
  garuda.networking.iwd = false;
  garuda.performance-tweaks.enable = true;
  garuda.performance-tweaks.cachyos-kernel = true;

  services.flatpak.enable = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
