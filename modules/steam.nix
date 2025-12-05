{inputs, pkgs, ...}:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    gamescopeSession.enable = true;
    protontricks.enable = true;
    extraCompatPackages = [
      pkgs.proton-ge-bin
      # pkgs.proton-cachyos_x86_64_v4
    ];
  };
  
  users.users.daniel = {
    extraGroups = [ "gamemode" ];
  };

  environment.systemPackages = [
    pkgs.wootility
  ];

  services.udev.packages = [
    pkgs.wooting-udev-rules
  ];
  
  programs.gamemode.enable = true;
}
