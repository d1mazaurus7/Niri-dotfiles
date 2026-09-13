{ ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    history = {
      size = 5000;
      save = 5000;
      share = true;
      ignoreAllDups = true;
      ignoreDups = true;
      ignoreSpace = true;
      append = true;
    };
    shellAliases = {
      # Short
      g = "git";
      t = "tree";
      qs = "quickshell";
      sw = "set-wallpaper";
      wp = "cd && cd Pictures/Wallpapers && imv .";
      cv = "cava";
      mpc-u = "mpc update --wait";
      
      # Configs 
      niriconf = "nvim ~/.config/niri/.";
      quickconf = "nvim ~/.config/quickshell/.";
      
      # NixOS
      nixos = "nvim /etc/nixos/.";
      rebuild = "cd /etc/nixos/ && git add . && sudo nixos-rebuild switch --flake .";
      update = "nix flake update --flake /etc/nixos";
      optimize = "nix-collect-garbage -d && nix-store --optimize";

      # Downloads 
      dl-s-video = "yt-dlp -P ~/.secret/p_videos/ -f 'bv*+ba/b' --merge-output-format mp4";
      dl-video = "yt-dlp -f 'bv*+ba/b' --merge-output-format mp4";
      dl-music = "yt-dlp -f bestaudio -x --audio-format mp3 --audio-quality 0 -o '~/Music/%(title)s.%(ext)s'";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "sudo"
        "git"
        "rust"
      ];
    };
    initContent = ''
      fastfetch
      eval "$(starship init zsh)"
    '';
  };
}
