{ config, ... }:
{
  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
        immediate_render = true;
        # grace = 0;
        # no_fade_in = false;
      };

      animations = {
        enabled = true;
        bezier = "easeOutQuint, 0.23, 1, 0.32, 1";
        animation = [
          "fadeIn, 1, 3, easeOutQuint"
          "fadeOut, 1, 3, easeOutQuint"
          "inputFieldDots, 1, 2, easeOutQuint"
        ];
      };

      background = [
        {
          monitor = "";
          path = "/home/valtrynx/.cache/current_wallpaper_link";
          blur_passes = 3;
          blur_size = 7;
          noise = 0.0118;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        }
      ];

      label = [
        # время
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(date +"%H:%M")"'';
          color = "rgba(255, 255, 255, 0.92)";
          font_size = 92;
          font_family = "Inter";
          position = "0, 120";
          halign = "center";
          valign = "center";
        }
        # дата
        {
          monitor = "";
          text = ''cmd[update:60000] echo "$(date +"%A, %d %B")"'';
          color = "rgba(255, 255, 255, 0.55)";
          font_size = 18;
          font_family = "Inter";
          position = "0, 40";
          halign = "center";
          valign = "center";
        }
        # user
        {
          monitor = "";
          text = "$USER";
          color = "rgba(255, 255, 255, 0.45)";
          font_size = 14;
          font_family = "Inter";
          position = "0, -140";
          halign = "center";
          valign = "center";
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "280, 48";
          position = "0, -80";
          halign = "center";
          valign = "center";
          fade_timeout = 0;
          fade_on_empty = true;

          outline_thickness = 1;
          dots_size = 0.25;
          dots_spacing = 0.35;
          dots_center = true;
          dots_rounding = -1;

          outer_color = "rgba(255, 255, 255, 0.12)";
          inner_color = "rgba(0, 0, 0, 0.28)";
          font_color = "rgba(255, 255, 255, 0.92)";
          check_color = "rgba(255, 255, 255, 0.35)";
          fail_color = "rgba(220, 90, 90, 0.85)";
          capslock_color = "rgba(255, 200, 80, 0.7)";

          placeholder_text = ''<span foreground="##ffffff66">пароль...</span>'';
          fail_text = ''<span foreground="##ff6b6b">неверный пароль</span>'';
          hide_input = false;
          rounding = 12;

          shadow_passes = 1;
          shadow_size = 6;
          shadow_color = "rgba(0, 0, 0, 0.4)";
        }
      ];
    };
  };
}
