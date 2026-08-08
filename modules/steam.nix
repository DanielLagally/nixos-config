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
      pkgs.proton-cachyos-x86_64_v3
    ];
  };
  
  users.users.daniel = {
    extraGroups = [ "gamemode" ];
  };

  # # cursed dynamic scheduler deployment

  # # 1. Allow your user to trigger scheduler and flags overrides without a password
  # security.sudo.extraRules = [
  #   {
  #     users = [ "daniel" ]; # Replace with your actual system username
  #     commands = [
  #       {
  #         command = "${pkgs.systemd}/bin/systemctl set-environment SCX_SCHEDULER_OVERRIDE=*";
  #         options = [ "NOPASSWD" ];
  #       }
  #       {
  #         command = "${pkgs.systemd}/bin/systemctl unset-environment SCX_SCHEDULER_OVERRIDE";
  #         options = [ "NOPASSWD" ];
  #       }
  #       {
  #         command = "${pkgs.systemd}/bin/systemctl set-environment SCX_FLAGS_OVERRIDE=*";
  #         options = [ "NOPASSWD" ];
  #       }
  #       {
  #         command = "${pkgs.systemd}/bin/systemctl unset-environment SCX_FLAGS_OVERRIDE";
  #         options = [ "NOPASSWD" ];
  #       }
  #       {
  #         command = "${pkgs.systemd}/bin/systemctl restart scx.service";
  #         options = [ "NOPASSWD" ];
  #       }
  #     ];
  #   }
  # ];

  # # 2. Configure GameMode to apply the scheduler, apply the flag, and revert on close
  programs.gamemode = {
    enable = true;
  #   settings = {
  #     custom = {
  #       start = ''
  #         ${pkgs.sudo}/bin/sudo ${pkgs.systemd}/bin/systemctl set-environment SCX_SCHEDULER_OVERRIDE=scx_lavd && \
  #         ${pkgs.sudo}/bin/sudo ${pkgs.systemd}/bin/systemctl set-environment SCX_FLAGS_OVERRIDE=--performance && \
  #         ${pkgs.sudo}/bin/sudo ${pkgs.systemd}/bin/systemctl restart scx.service
  #       '';
  #       end = ''
  #         ${pkgs.sudo}/bin/sudo ${pkgs.systemd}/bin/systemctl unset-environment SCX_SCHEDULER_OVERRIDE && \
  #         ${pkgs.sudo}/bin/sudo ${pkgs.systemd}/bin/systemctl unset-environment SCX_FLAGS_OVERRIDE && \
  #         ${pkgs.sudo}/bin/sudo ${pkgs.systemd}/bin/systemctl restart scx.service
  #       '';
  #     };
  #   };
  };

  environment.systemPackages = [
    pkgs.aseprite
    pkgs.scrcpy
  ];

  boot.kernelModules = [ "ntsync" ];

  hardware.wooting.enable = true;
}
