{ pkgs, config, ... }:

{
  # karakeep
  services.karakeep = {
    enable = true;
    environmentFile = "${config.users.users.daniel.home}/.config/karakeep/karakeep.env";
    browser.exe = "${pkgs.chromium}/bin/chromium";
  };


  # Enable the Docker daemon
  virtualisation.docker.enable = true;

  # Declarative container management
  virtualisation.oci-containers = {
    backend = "docker";
    containers.feedcord = {
      image = "qolors/feedcord:latest";
      autoStart = true;
      
      volumes = [
        # Map your local configuration file into the container
        "/var/lib/feedcord:/app/config"
      ];

      # Network configuration
      # Use "host" networking if FeedCord needs to talk to a Karakeep instance 
      # running on the same machine's localhost/loopback interface.
      extraOptions = [ "--network=host" ];
    };
  };
}
