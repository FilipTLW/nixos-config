{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {
    nixpkgs,
    ...
  }: {
    packages.x86_64-linux.vimix-cursors = nixpkgs.legacyPackages.x86_64-linux.pkgs.vimix-cursors;
  };
}
