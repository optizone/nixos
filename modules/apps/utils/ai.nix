{
  inputs,
  pkgs,
  username,
  ...
}: let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
  };
in {
  home-manager.users.${username} = {
    home.packages = [
      unstable.ollama-vulkan
      unstable.pi-coding-agent
    ];

    programs.opencode = {
      enable = true;
      tui.theme = "gruvbox";
      package = unstable.opencode;

      settings = {
        default_agent = "plan";

        plugin = [
          "@dietrichgebert/ponytail"
        ];

        autoupdate = false;
        provider.ollama = {
          npm = "@ai-sdk/openai-compatible";
          name = "Ollama";
          options = {
            baseURL = "http://127.0.0.1:11434/v1";
          };

          models = {
            "qwen3.6:35b" = {
              name = "qwen3.6:35b";
              reasoning = true;
              tools = true;
            };

            "gemma4:12b" = {
              name = "gemma4:12b";
              reasoning = true;
              tools = true;
            };

            "qwen3:0.6b" = {
              name = "qwen3:0.6b";
              reasoning = true;
              tools = true;
            };
          };
        };
      };
    };
  };
}
