{
  pkgs,
  lib,
  config,
  ...
}: {
  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
    # dockerCompat = true;
  };

  # Enable container name DNS for all Podman networks.
  networking.firewall.interfaces = let
    matchAll =
      if !config.networking.nftables.enable
      then "podman+"
      else "podman*";
  in {
    "${matchAll}".allowedUDPPorts = [53];
  };

  virtualisation.oci-containers.backend = "podman";

  # Containers
  virtualisation.oci-containers.containers."hortusfox-app" = {
    image = "ghcr.io/danielbrendel/hortusfox-web:v5.7";
    environment = {
      "APP_ADMIN_EMAIL" = "admin@example.com";
      "APP_ADMIN_PASSWORD" = "password";
      "APP_TIMEZONE" = "UTC";
      "DB_CHARSET" = "utf8mb4";
      "DB_DATABASE" = "hortusfox";
      "DB_HOST" = "db";
      "DB_PASSWORD" = "password";
      "DB_PORT" = "3306";
      "DB_USERNAME" = "user";
    };
    volumes = [
      "hortusfox_app_backup:/var/www/html/public/backup:rw"
      "hortusfox_app_images:/var/www/html/public/img:rw"
      "hortusfox_app_logs:/var/www/html/app/logs:rw"
      "hortusfox_app_migrate:/var/www/html/app/migrations:rw"
      "hortusfox_app_themes:/var/www/html/public/themes:rw"
    ];
    ports = [
      "8080:80/tcp"
    ];
    dependsOn = [
      "hortusfox-db"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=app"
      "--network=hortusfox_default"
    ];
  };

  systemd.services."podman-hortusfox-app" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "no";
    };
    after = [
      "podman-network-hortusfox_default.service"
      "podman-volume-hortusfox_app_backup.service"
      "podman-volume-hortusfox_app_images.service"
      "podman-volume-hortusfox_app_logs.service"
      "podman-volume-hortusfox_app_migrate.service"
      "podman-volume-hortusfox_app_themes.service"
    ];
    requires = [
      "podman-network-hortusfox_default.service"
      "podman-volume-hortusfox_app_backup.service"
      "podman-volume-hortusfox_app_images.service"
      "podman-volume-hortusfox_app_logs.service"
      "podman-volume-hortusfox_app_migrate.service"
      "podman-volume-hortusfox_app_themes.service"
    ];
    partOf = [
      "podman-compose-hortusfox-root.target"
    ];
    wantedBy = [
      "podman-compose-hortusfox-root.target"
    ];
  };
  virtualisation.oci-containers.containers."hortusfox-db" = {
    image = "mariadb";
    environment = {
      "MARIADB_DATABASE" = "hortusfox";
      "MARIADB_PASSWORD" = "password";
      "MARIADB_ROOT_PASSWORD" = "my-secret-pw";
      "MARIADB_USER" = "user";
    };
    volumes = [
      "hortusfox_db_data:/var/lib/mysql:rw"
    ];
    ports = [
      "3306:3306/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=db"
      "--network=hortusfox_default"
    ];
  };
  systemd.services."podman-hortusfox-db" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-hortusfox_default.service"
      "podman-volume-hortusfox_db_data.service"
    ];
    requires = [
      "podman-network-hortusfox_default.service"
      "podman-volume-hortusfox_db_data.service"
    ];
    partOf = [
      "podman-compose-hortusfox-root.target"
    ];
    wantedBy = [
      "podman-compose-hortusfox-root.target"
    ];
  };

  # Networks
  systemd.services."podman-network-hortusfox_default" = {
    path = [pkgs.podman];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "podman network rm -f hortusfox_default";
    };
    script = ''
      podman network inspect hortusfox_default || podman network create hortusfox_default
    '';
    partOf = ["podman-compose-hortusfox-root.target"];
    wantedBy = ["podman-compose-hortusfox-root.target"];
  };

  # Volumes
  systemd.services."podman-volume-hortusfox_app_backup" = {
    path = [pkgs.podman];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      podman volume inspect hortusfox_app_backup || podman volume create hortusfox_app_backup
    '';
    partOf = ["podman-compose-hortusfox-root.target"];
    wantedBy = ["podman-compose-hortusfox-root.target"];
  };
  systemd.services."podman-volume-hortusfox_app_images" = {
    path = [pkgs.podman];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      podman volume inspect hortusfox_app_images || podman volume create hortusfox_app_images
    '';
    partOf = ["podman-compose-hortusfox-root.target"];
    wantedBy = ["podman-compose-hortusfox-root.target"];
  };
  systemd.services."podman-volume-hortusfox_app_logs" = {
    path = [pkgs.podman];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      podman volume inspect hortusfox_app_logs || podman volume create hortusfox_app_logs
    '';
    partOf = ["podman-compose-hortusfox-root.target"];
    wantedBy = ["podman-compose-hortusfox-root.target"];
  };
  systemd.services."podman-volume-hortusfox_app_migrate" = {
    path = [pkgs.podman];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      podman volume inspect hortusfox_app_migrate || podman volume create hortusfox_app_migrate
    '';
    partOf = ["podman-compose-hortusfox-root.target"];
    wantedBy = ["podman-compose-hortusfox-root.target"];
  };
  systemd.services."podman-volume-hortusfox_app_themes" = {
    path = [pkgs.podman];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      podman volume inspect hortusfox_app_themes || podman volume create hortusfox_app_themes
    '';
    partOf = ["podman-compose-hortusfox-root.target"];
    wantedBy = ["podman-compose-hortusfox-root.target"];
  };
  systemd.services."podman-volume-hortusfox_db_data" = {
    path = [pkgs.podman];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      podman volume inspect hortusfox_db_data || podman volume create hortusfox_db_data
    '';
    partOf = ["podman-compose-hortusfox-root.target"];
    wantedBy = ["podman-compose-hortusfox-root.target"];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."podman-compose-hortusfox-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = ["multi-user.target"];
  };
}
