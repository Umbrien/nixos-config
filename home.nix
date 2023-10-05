{ home-manager, pkgs, ... }:
{
  imports = [
    ./packages.nix
  ];
  home.stateVersion = "23.05";

  home.sessionVariables = {
    EDITOR = "vim";
    TERM = "alacritty";
  };

  programs.git = {
    enable = true;
    userName = "Umbrien";
    userEmail = "kaluhin.dev@gmail.com";
  };

  programs.bash = {
    shellAliases = {
      q = "exit";
      v = "vim";
      rb = "sudo nixos-rebuild switch --flake ~/.config/nix-config/";
    };
  };
}