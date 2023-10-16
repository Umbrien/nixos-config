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

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      bbenoist.nix
      justusadam.language-haskell
    ];
  };
}