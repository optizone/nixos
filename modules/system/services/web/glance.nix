_: {
  services.glance = {
    enable = true;

    settings = {
      server = {
        host = "127.0.0.1";
        port = 8081;
      };

      pages = [
        {
          name = "Staerpage";
          width = "slim";

          hide-desktop-navigation = true;
          center-vertically = true;

          columns = [
            {
              size = "full";

              widgets = [
                {
                  type = "search";
                  autofocus = true;
                }

                {
                  type = "monitor";
                  cache = "1m";
                  sites = [
                    {
                      title = "Jellyfin";
                      url = "http://jellyfin.home.arpa";
                    }
                  ];
                }

                {
                  type = "dns-stats";
                  service = "adguard";
                  url = "http://adguard.home.arpa";
                  username = "admin";
                  password = "admin";
                }

                {
                  type = "server-stats";
                  servers = [
                    {
                      type = "remote";
                      url = "rpi5-k";
                    }
                  ];
                }
              ];
            }
          ];
        }
      ];
    };
  };
}
