# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, unstable, inputs, ... }:

{
  networking.hostName = "tower";

  imports = [ 
      ./../modules/basics.nix
      ./hardware-configuration.nix
      ./../modules/nvidia.nix
      ./../modules/hyprland.nix
      ./../modules/steam.nix
      ./../modules/music.nix
      ./../modules/japanese.nix
      inputs.musnix.nixosModules.musnix
      ./../modules/home-modules/common.nix
    ];

  environment.systemPackages = [
    # (unstable.discord.override {
    #   withOpenASAR = true;
    #   withVencord = true;
    # })
    unstable.vesktop
    unstable.anki
    unstable.prismlauncher
    unstable.obsidian
    unstable.shipwright
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # audio  
  musnix.enable = true;
  musnix.rtcqs.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

#  security.pam.loginLimits = [
#    { domain = "@audio"; item = "memlock"; type = "hard"  ; value = "unlimited"; }
#    { domain = "@audio"; item = "rtprio" ; type = "hard"  ; value = "99"       ; }
#    { domain = "@audio"; item = "nofile" ; type = "soft"  ; value = "99999"    ; }
#    { domain = "@audio"; item = "nofile" ; type = "hard"  ; value = "99999"    ; }
#  ];

  services.udev.extraRules = ''
    KERNEL=="rtc0", GROUP="audio"
    KERNEL=="hpet", GROUP="audio"
  '';

  # timezones
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.daniel = {
    isNormalUser = true;
    description = "daniel";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
    packages = with unstable; [];
  };

  powerManagement.cpuFreqGovernor = "performance";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
    # enable = true;
    # enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # flash drive functionality
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 25565 ];
  networking.firewall.allowedUDPPorts = [ 25565 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
