vim.g.mapleader = " "
vim.g.maplocalleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { "folke/which-key.nvim", event = "VeryLazy", opts = {}, },
    { 'akinsho/toggleterm.nvim', version = "*", config = true},
    { "catgoose/nvim-colorizer.lua", event = "BufReadPre", opts = {}, },
    { "nvim-tree/nvim-tree.lua", opts = {}, },
    { "neovim/nvim-lspconfig" },
    {
      "saghen/blink.cmp",
      version = "1.*",
      build = "cargo build --release",
      dependencies = {"rafamadriz/friendly-snippets"},
      opts = {
        keymap = { preset = "enter" },
        completion = { documentation = { auto_show = false } },
        list = {
            selection = { preselect = false, auto_insert = false },
        },
        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
        },
        fuzzy = { implementation = "prefer_rust_with_warning" },
      },
      opts_extend = { "sources.default" },
    },
    {"m4xshen/autoclose.nvim", opts= {}, },
    {
      'romgrk/barbar.nvim',
      init = function() vim.g.barbar_auto_setup = false end,
      opts = {},
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts ={},
    },
    {
    '2kabhishek/nerdy.nvim',
        dependencies = {
            'folke/snacks.nvim',
            -- or 'ibhagwan/fzf-lua',
            -- or 'nvim-telescope/telescope.nvim',
        },
        cmd = 'Nerdy',
        opts = {
            max_recents = 30, -- Configure recent icons limit
            copy_to_clipboard = false, -- Copy glyph to clipboard instead of inserting
            copy_register = '+', -- Register to use for copying (if `copy_to_clipboard` is true)
            picker = 'auto', -- 'auto' (default) | 'snacks' | 'fzf-lua' | 'telescope' | 'select'
        },
    },
    { "nvim-tree/nvim-web-devicons", opts = {}, },
    {
      'mrcjkb/rustaceanvim',
      version = '^9',
      lazy = false,
      init = function()
        vim.api.nvim_create_autocmd("LspAttach", {
          callback = function(args)
            local buf = args.buf
            
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = buf, desc = 'LSP Hover' })
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = buf, desc = 'LSP Definition' })
            vim.keymap.set('n', '<leader>ca', function()
              vim.cmd.RustLsp('codeAction')
            end, { buffer = buf, desc = 'Rust Code Action' })
            
          end,
        })
      end
    },
    {
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      opts = function()
        local theme = vim.deepcopy(require("lualine.themes.auto"))
        local hl = vim.api.nvim_get_hl(0, {
          name = "StatusLine",
          link = false,
        })
        local bg = hl.bg and string.format("#%06x", hl.bg) or "NONE"
        for _, mode in pairs(theme) do
          for _, section in pairs(mode) do
            section.bg = bg
          end
        end

        return {
          options = {
            theme = theme,
            icons_enabled = true,
            component_separators = { left = "", right = "" },
          },

          sections = {
            lualine_a = { "mode", "filename" },
            lualine_b = { "diagnostics" },
            lualine_c = {},
            lualine_x = { "fileformat", "filetype" },
            lualine_y = { "progress" },
            lualine_z = { "location" },
          },
        }
      end,
    },
  },
  -- Colorscheme
  install = { colorscheme = { "tokyonight-night" } },

  -- Check for updates (plugins)
  checker = { enabled = true }
})

