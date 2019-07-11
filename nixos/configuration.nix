# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Apply Skylake/CAVE Audio hacks
      ./cave-audio.nix
    ];

  # --- Use the GRUB 2 boot loader + legacy boot (for dual-boot with ChromeOS)
  # boot.loader.grub.enable = true;
  # boot.loader.grub.version = 2;
  # boot.loader.grub.device = "/dev/mmcblk0"; # or "nodev" for efi only
  # boot.loader.grub.forceInstall = true;
  # --- Use EFI boot with systemd-boot (after full firmware replacement)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "pixie"; # Define your hostname.
  networking.networkmanager.enable = true;
  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # List packages installed in system profile.
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    curl
    mkpasswd
    vim
    firefox
    fuse
    git
    vscode
    file
    powertop
    chromium
    xclip
    (python37.withPackages(ps: with ps; [ numpy jupyter ]))
 ];
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

  # Enable bluetooth.
  hardware.bluetooth.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";

  # Enable touchpad support.
  services.xserver.libinput = {
    enable = true;
    clickMethod = "clickfinger";
    tapping = false;
    disableWhileTyping = true;
  };
  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  security.sudo.wheelNeedsPassword = false;
  users.mutableUsers = false;
  users.users.jlong = {
    isNormalUser = true;
    uid = 1000;
    hashedPassword = "$6$guct7OcujBT6f5$cKmtwXLZBbNLPv44/0GWfbRobitC2QyQUTaak3.r5Im//vlfivTYjEitcVInLz7ZP3/vJitQ4yhBWe8Nrx4Ci0";
    extraGroups = [
      "wheel"            # Enable ‘sudo’ for the user.
      "networkmanager"   # Enable managing network connections
    ];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?

}
