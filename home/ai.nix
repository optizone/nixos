{
  inputs,
  pkgs,
  host,
  username,
  ...
}: let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
  };
in {
  home.packages = [
    unstable.ollama-vulkan
    unstable.pi-coding-agent
  ];

  programs.opencode = {
    enable = true;
    tui.theme = "gruvbox";

    settings = {
      default_agent = "plan";

      plugin = [
        "@dietrichgebert/ponytail"
      ];

      autoupdate = false;
    };
  };

  # TODO: add all dirs

  # TODO: move to modules, now does not build

  # environment.persistence."/zroot/ldata/persist/${host}" = {
  #   users.${username}.directories = [
  #     ".pi"
  #     ".ollama"
  #   ];
  # };

  # NOTE:
  # /var/lib/private/ollama -> service.ollama
}
