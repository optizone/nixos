{ lib, ... }:
{
  config.vim = {
    augroups = [
      {
        name = "layout-switch";
        clear = true;
      }
    ];

    globals.main_keyboard_layout_update = lib.generators.mkLuaInline ''
      (function()
        local state = { kb_name = nil, insert_kl = nil, other_kl = nil }

        local function impl(into_insert)
          local query_template = "hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | %s'"

          if state.kb_name == nil then
            state.kb_name = vim.fn.system(query_template:format(".name")):gsub("\r?\n", "")
          end

          local kl = vim.fn.system(query_template:format(".active_keymap")):sub(1, 2):lower()

          if (kl == "en") then
            kl = 0
          elseif (kl == "ru") then
            kl = 1
          else 
            vim.notify(string.format("Unknown keyboard layout '%s'. Defaulting to us.", kl))
            kl = 0
          end

          if state.insert_kl == nil then
            state.insert_kl = kl
          end

          if state.other_kl == nil then
            state.other_kl = kl
          end

          local switch_template = string.format( 'hyprctl switchxkblayout %s ', state.kb_name)..'%d'
          if into_insert then
            state.other_kl = kl
            vim.fn.system(switch_template:format(state.insert_kl))
          else
            state.insert_kl = kl
            vim.fn.system(switch_template:format(state.other_kl))
          end
        end

        return impl
      end)()
    '';

    autocmds = [
      {
        event = [ "InsertEnter" ];
        group = "layout-switch";
        callback = lib.generators.mkLuaInline ''
          function()
            vim.g.main_keyboard_layout_update(true)
          end
        '';
      }

      {
        event = [ "InsertLeave" ];
        group = "layout-switch";
        callback = lib.generators.mkLuaInline ''
          function()
            vim.g.main_keyboard_layout_update(false)
          end
        '';
      }
    ];
  };
}
