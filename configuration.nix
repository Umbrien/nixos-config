{ config, pkgs, ... }:

let user = "ted"; in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "sus"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager = {
      enable = true;
      wifi = {
        macAddress = "random";
        backend = "iwd";
        powersave = true;
        scanRandMacAddress = true;
      };
    };

  # Set your time zone.
  time.timeZone = "Europe/Kyiv";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "uk_UA.UTF-8";
    LC_IDENTIFICATION = "uk_UA.UTF-8";
    LC_MEASUREMENT = "uk_UA.UTF-8";
    LC_MONETARY = "uk_UA.UTF-8";
    LC_NAME = "uk_UA.UTF-8";
    LC_NUMERIC = "uk_UA.UTF-8";
    LC_PAPER = "uk_UA.UTF-8";
    LC_TELEPHONE = "uk_UA.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
  };

  boot.kernelParams = ["reboot=acpi"];

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];

    dpi = 96;

    # Enable the Pantheon Desktop Environment.
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;

    layout = "us,ru";
    xkbOptions = "grp:win_space_toggle";
    # xkbOptions = "ctrl:swapcaps,grp:win_space_toggle";
  };

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    dataDir = "/home/${user}/Documents";
    configDir = "/home/${user}/.config/syncthing";
    user = user;

    # web GUI port is 8384 by default

    overrideDevices = true;
    devices = {
      "Redmi Note 9 Pro @pixel-experience" = {
        id = "4KCIINW-64SW374-S735IPS-MJOHYCK-3ZAYJ3R-T4QGTZG-OIYHI6J-2PVNGAG";
        autoAcceptFolders = true;
      };
    };

    overrideFolders = true;
    folders = {
      "keepass" = {
        id = "7we7e-vqjmr";
        path = "/home/${user}/Documents/keepass";
        devices = ["Redmi Note 9 Pro @pixel-experience"];
      };
    };
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    description = "Theodore Kaczynski";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim 
    wget
    killall xorg.xkill
    git
    man
    cloudflare-warp
  ];

  systemd.services.warp-svc = {
    enable = true;
    description = "Cloudflare Warp service";
    unitConfig = {
      Type = "simple";
    };
    serviceConfig = {
      ExecStart = "/run/current-system/sw/bin/warp-svc";
    };
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
  };

  environment.shellAliases = {
    q = "exit";
    v = "vim";
    rb = "sudo nixos-rebuild switch --flake /home/${user}/.config/nix-config/";
  };

  # programs.firefox = {
  #   enable = true;
 
  #   extensions = with pkgs.nur.repos.rycee.firefox-addons; [
  #     darkreader
  #   ];
  # };

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

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
