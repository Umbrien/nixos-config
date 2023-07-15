# NixOS config

rebuild system after modifying config:

`sudo nixos-rebuild switch --flake /home/ted/.config/nix-config/`

Cleanup:
```bash
sudo nix-collect-garbage --delete-older-than 30d

nix store optimise

sudo nix-collect-garbage -d
```