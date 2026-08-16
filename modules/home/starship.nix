{ pkgs, ... }:
{
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      presets = [
        "nerd-font-symbols"
      ];
      settings = {
        format = "$all";
        add_newline = false;
        scan_timeout = 10;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
        rust = {
          symbol = "";
          style = "bold fg:#ff9e64";
        };
        python = {
          symbol = "";
          style = "bold fg:#c9c122";
        };
        java = {
          symbol = "";
          style = "bold fg:#c43b12";
        };
        nodejs = {
          symbol = "";
          style = "bold fg:#199cb0";
       };
      };
    };
}

