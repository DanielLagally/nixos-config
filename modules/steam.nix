{inputs, unstable, ...}:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    gamescopeSession.enable = true;
    protontricks.enable = true;
    extraCompatPackages = [
      unstable.proton-ge-bin
    ];
  };
  
  users.users.daniel = {
    extraGroups = [ "gamemode" ];
  };
  
  programs.gamemode.enable = true;
}
