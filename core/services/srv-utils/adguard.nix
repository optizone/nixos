{ domain, ... }:
{
  services.adguardhome = {
    enable = true;
    openFirewall = true;

    settings = {
      dns = {
        upstream_dns = [
          "https://dns10.quad9.net/dns-query"
        ];

        bootstrap_dns = [ "tls://1.1.1.1" ];
      };

      filtering = {
        protection_enabled = true;
        filtering_enabled = true;

        rewrites = [
          {
            domain = "*.${domain}";
            answer = "192.168.68.118";
            enabled = true;
          }

          {
            domain = "rpi5-k";
            answer = "192.168.68.118";
            enabled = true;
          }
        ];
      };

      filters = [
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
          name = "AdGuard DNS filter";
        }

        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_2.txt";
          name = "AdAway Default Blocklist";
        }

        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_59.txt";
          name = "AdGuard DNS Popup Hosts filter";
        }

        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_49.txt";
          name = "HaGeZi's Ultimate Blocklist";
        }

        {
          enabled = false;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_46.txt";
          name = "HaGeZi's Anti-Piracy Blocklist";
        }

        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_30.txt";
          name = "Phishing URL Blocklist (PhishTank and OpenPhish)";
        }

        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_67.txt";
          name = "HaGeZi's Apple Tracker Blocklist";
        }

        {
          enabled = false;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_37.txt";
          name = "No Google";
        }

        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt";
          name = "Malicious URL Blocklist (URLHaus)";
        }

        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_50.txt";
          name = "uBlock₀ filters – Badware risks";
        }
      ];
    };
  };
}
