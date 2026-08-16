{ pkgs, ... }: 
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      dl-music = "yt-dlp -f bestaudio -x --audio-format mp3 --audio-quality 0 -o '~/Music/%(title)s.%(ext)s'";
      dl-video = "yt-dlp -f 'bv*+ba/b' --merge-output-format mp4";
      niriconf = "nvim ~/.config/niri/config.kdl";
      wayconf = "cd ~/.config/waybar/";
      ffconf = "nvim ~/.config/fastfetch/config.jsonc";
      nixconf = "nvim /etc/nixos/";
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
    };
    initExtra = ''
      if [[ -o interactive ]]; then
        fastfetch
      fi
    '';
    oh-my-zsh = {
      enable = true;
      plugins = [ "sudo" "git" ];
    };
  };
}
