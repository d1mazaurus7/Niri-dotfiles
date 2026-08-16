{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      lua-language-server
      rust-analyzer
      gopls
      clang-tools
      marksman
      taplo
      nil
      pyright
      stylua
      nixpkgs-fmt
      ripgrep
      fd
      typescript-language-server
      bash-language-server
      yaml-language-server
      vscode-langservers-extracted
      dockerfile-language-server-nodejs
    ];

    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
      lualine-nvim
      nvim-web-devicons
      indent-blankline-nvim
      gitsigns-nvim
      which-key-nvim
      nvim-autopairs
      comment-nvim
      todo-comments-nvim
      toggleterm-nvim
      nvim-tree-lua
      telescope-nvim
      telescope-fzf-native-nvim
      oil-nvim
      flash-nvim
      nvim-treesitter.withAllGrammars
      nvim-treesitter-textobjects
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      luasnip
      cmp_luasnip
      friendly-snippets
      trouble-nvim
      nvim-surround
      vim-sleuth
      nvim-highlight-colors
    ];

    extraLuaConfig = builtins.readFile ./nvim/init.lua;
  };
}
