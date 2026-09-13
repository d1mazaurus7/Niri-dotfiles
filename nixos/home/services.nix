{ pkgs, config, ... }:
{
services.mpd = {
  enable = true;
  musicDirectory = "${config.home.homeDirectory}/Music";
  extraConfig = ''
    audio_output {
      type "pipewire"
      name "PipeWire"
     }
    '';
    };

    services.mpd-mpris.enable = true;
}
