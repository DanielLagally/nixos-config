{ pkgs, config, ... }:

{
  # karakeep
  services.karakeep = {
    enable = true;
    environmentFile = "${config.users.users.daniel.home}/.config/karakeep/karakeep.env";
    browser.exe = "${pkgs.chromium}/bin/chromium";

    # Node.js 24.19.0 shipped a regression (nodejs/node#63642) that reliably
    # SIGABRTs NAN-style native addons like better-sqlite3 under GC pressure
    # -- in practice this fires on almost every crawl, crash-looping the
    # workers service. Build karakeep against nodejs_22 (LTS, unaffected)
    # until nixpkgs/Node ship a fix. Revert once nodejs_24 is patched.
    package = pkgs.karakeep.override { nodejs = pkgs.nodejs_22; };
  };

  # Keep as a general safety net (harmless if the above override makes it
  # unnecessary for this specific bug).
  systemd.services.karakeep-web.serviceConfig = {
    Restart = "on-failure";
    RestartSec = "5s";
  };
  systemd.services.karakeep-workers.serviceConfig = {
    Restart = "on-failure";
    RestartSec = "5s";
  };


  # Caddy: reverse proxy + automatic Let's Encrypt HTTPS in front of the
  # persistent rumination instance. That instance must be started with
  # `--addr 127.0.0.1:18080` (loopback-only, so unreachable from outside
  # this host regardless of firewall/port-forwarding either way) --
  # deliberately NOT rumination's default port/addr (127.0.0.1:8080, see
  # its src/cli.rs), so an ad hoc `cargo run -- server` for local dev
  # testing doesn't collide with this long-running instance on the same
  # machine.
  services.caddy = {
    enable = true;
    email = "daniel.lagally@gmail.com";
    virtualHosts."ruminate.duckdns.org".extraConfig = ''
      reverse_proxy localhost:18080
    '';
  };

  # 80/443 for Caddy's ACME HTTP-01 challenge + HTTPS itself. Kept here
  # (rather than the host's general firewall list) so the port
  # requirement travels with the service that needs it.
  networking.firewall.allowedTCPPorts = [ 80 443 ];

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
