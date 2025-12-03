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
      inputs.chaotic.legacyPackages.x86_64-linux.proton-cachyos_x86_64_v4
    ];
  };
  
  users.users.daniel = {
    extraGroups = [ "gamemode" ];
  };

  environment.systemPackages = [
    unstable.wootility
  ];

  services.udev.packages = [
    unstable.wooting-udev-rules
  ];
  
  programs.gamemode.enable = true;
}
