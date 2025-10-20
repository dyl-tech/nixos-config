{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan
      ./hardware-configuration.nix
    ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Define hostname
  networking.hostName = "nixos";

  # Enable networking
  networking.networkmanager.enable = true;

  # Wireguard
  networking.wireguard.enable = true;

  # Set time zone
  time.timeZone = "America/Chicago";
  time.hardwareClockInLocalTime = true;

  # Select internationalisation properties
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system
  services.xserver.enable = true;

  # Enable GNOME
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents
  services.printing.enable = true;

  # Enable sound with pipewire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # User stuff
  users.users.dyl = {
    isNormalUser = true;
    description = "dyl";
    extraGroups = [ "networkmanager" "libvirtd" "wheel" ];
    shell = pkgs.fish;  # Makes fish the default
    packages = with pkgs; [
    ];
  };

  # Swap
  swapDevices = [
    { device = "/swapfile"; size = 32768; }
  ];

  # Allow fish as a login shell
  programs.fish.enable = true;

  # Install firefox
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Flatpak
  services.flatpak.enable = true;

  # Packages
  environment.systemPackages = with pkgs; [
    vim
    neovim
    fastfetch
    kitty
    discord
    steam
    wget
    btop
    gparted
    pciutils
    git
    gnome-extension-manager
    prismlauncher
    gnome-tweaks
    libreoffice-fresh
    qbittorrent
    gimp
    cmatrix
    brave
    vivaldi
    tor-browser
    librewolf
    gnome-boxes
    telegram-desktop
    ntfs3g
    vlc
    thunderbird
    mullvad-vpn
    obs-studio
    blender
    wireshark
    mediawriter
    wireguard-tools
  ];

  boot.blacklistedKernelModules = [ "nouveau" ];

  # Enable NVIDIA + AMD hybrid graphics (Zephyrus G14)
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      vulkan-tools
      vulkan-validation-layers
      vulkan-loader
    ];
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    nvidiaSettings = true;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.latest;

    prime = {
      offload.enable = true;
      amdgpuBusId = "PCI:101:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # Enable Steam support
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Only the WMI module your laptop uses
  boot.kernelModules = [ "asus-wmi" ];

  # Enable Supergfxctl (GPU switching)
  services.supergfxd.enable = true;

  # Temporary fix for GPU detection (safe even if not needed later)
  systemd.services.supergfxd.path = [ pkgs.pciutils ];

  # Enable Asus control daemon + user service
  services.asusd = {
    enable = true;
    enableUserService = true;
  };

  # Virtualization stuff
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  
  # System state version
  system.stateVersion = "25.05";
}
