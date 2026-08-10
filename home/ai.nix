{pkgs, ...}: let
  zai = pkgs.writeShellScriptBin "zai" ''
    # TODO: add usage check. arguments
    #   - <ACTION>: [ code chat pull ], default code
    #   - <MODEL>:
    #     if action == code then [ qwen3.6:35b gemma4:12b ], default qwen3.6:35b
    #     if action == chat then [ deepseek-r1:32b ], default deepseek-r1:32b
    #     if action == pull then all above, default all
    MODEL="$1"
    [ -z "$MODEL" ] && MODEL="ollama/gemma4:12b"


    echo "starting ollama..."
    SERVER_PID=$(
            OLLAMA_VULKAN=1 \
            OLLAMA_IGPU_ENABLE=1 \
            OLLAMA_CONTEXT_LENGTH=64000 \
            ollama serve >/dev/null 2>&1 & \
            echo $!
    )

    trap 'kill $SERVER_PID 2>/dev/null; wait $SERVER_PID || true' EXIT

    echo ""
    echo "starting opencode..."
    ollama launch opencode

    echo "waiting ollama serve to shutdown..."
    wait $SERVER_PID
  '';
in {
  home.packages = with pkgs; [
    ollama-vulkan
    pi-coding-agent
    zai
  ];

  programs.opencode = {
    enable = true;
    tui.theme = "gruvbox";

    settings = {
      default_agent = "plan";

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
}
