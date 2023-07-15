{ home-manager, pkgs, ... }:
{
  imports = [
    ./packages.nix
  ];
  home.stateVersion = "23.05";
}