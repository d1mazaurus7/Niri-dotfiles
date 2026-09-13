{ pkgs, config, ... }:
{
  home.pointerCursor = {
    enable = true;
    name = "catppuccin-macchiato-dark-cursors";
    package = pkgs.catppuccin-cursors.macchiatoDark;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
};

home.sessionVariables = {
  XCURSOR_THEME = "catppuccin-macchiato-dark-cursors";
  XCURSOR_SIZE = "24";
  XCURSOR_PATH = "${config.home.homeDirectory}/.icons:${config.home.homeDirectory}/.local/share/icons";
  };
}
