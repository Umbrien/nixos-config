{ pkgs, ... }:
let
  wasp = pkgs.stdenv.mkDerivation rec{
    pname = "wasp";
    version = "0.11.0";
    name = "wasp-${version}";
    dontStrip = true;
        
    src = builtins.fetchurl {
      url =
        "https://github.com/wasp-lang/wasp/releases/download/v${version}/wasp-linux-x86_64.tar.gz";
        sha256 = "1izjqwmdmqzkns2qpb7fyjcqlcyz9fjhkz48ll6zrrrh83mvi8a5";
      };
      nativeBuildInputs = with pkgs; [ makeWrapper patchelf prisma-engines ];
      buildInputs = with pkgs; [ prisma-engines nodePackages.prisma ];

      unpackPhase = ''
        tar xzf $src
      '';
          
      installPhase = let
        libPath = pkgs.lib.makeLibraryPath [
          pkgs.zlib
          pkgs.gmp
        ];
      in ''
        mkdir -p $out/bin
        cp wasp-bin $out/bin/wasp
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath "${libPath}" $out/bin/wasp

        wrapProgram $out/bin/wasp \
          --set waspc_datadir /home/ted/.local/share/wasp/data \
          --set PRISMA_MIGRATION_ENGINE_BINARY "${pkgs.prisma-engines}/bin/migration-engine" \
          --set PRISMA_QUERY_ENGINE_BINARY "${pkgs.prisma-engines}/bin/query-engine" \
          --set PRISMA_QUERY_ENGINE_LIBRARY "${pkgs.prisma-engines}/lib/libquery_engine.node" \
          --set PRISMA_INTROSPECTION_ENGINE_BINARY "${pkgs.prisma-engines}/bin/introspection-engine" \
          --set PRISMA_FMT_BINARY "${pkgs.prisma-engines}/bin/prisma-fmt"
      '';
  };
  
in {
  home.packages = with pkgs; [
    firefox
    telegram-desktop
    discord

    vscode
    nodejs_18
    wasp

    keepassxc

    obs-studio

    alacritty
    flameshot
    mpv
    
    pavucontrol
    qpwgraph

    tldr
    direnv
  ];
}