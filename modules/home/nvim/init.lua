-- Options
local o = vim.opt
o.number = true
o.relativenumber = true
o.mouse = "a"
o.clipboard = "unnamedplus"
o.ignorecase = true
o.smartcase = true
o.hlsearch = false
o.incsearch = true
o.termguicolors = true
o.signcolumn = "yes"
o.scrolloff = 8
o.updatetime = 250
o.timeoutlen = 300
o.splitright = true
o.splitbelow = true
o.undofile = true
o.swapfile = false
o.completeopt = "menu,menuone,noselect"

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-------------------------
------(  Setups  ) ------
-------------------------

--------------------
---- nvim-tree: ----
--------------------
local ok_tree, nvim_tree = pcall(require, "nvim-tree")
if ok_tree then
  nvim_tree.setup({
    view = {
      width = 30,
    },
    renderer = {
      group_empty = true,
    },
    filters = {
      dotfiles = false,
    },
  })
end

-------------------------
---- nvim-autopairs: ----
-------------------------
local ok_autopairs, autopairs = pcall(require, "nvim-autopairs")
if ok_autopairs then
  autopairs.setup({
    check_ts = true,
    disable_filetype = { "TelescopePrompt", "vim" },
  })
end

--------------------
---- nvim-cmp: -----
--------------------
local ok_cmp, cmp = pcall(require, "cmp")
local ok_luasnip, luasnip = pcall(require, "luasnip")

if ok_cmp and ok_luasnip then
  require("luasnip.loaders.from_vscode").lazy_load()

  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered({
        max_width = 60,
        max_height = 15,
      }),
    },
    view = { docs = { auto_open = false } },
    mapping = cmp.mapping.preset.insert({
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-d>"] = cmp.mapping.scroll_docs(4),
      ["<C-u>"] = cmp.mapping.scroll_docs(-4),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "path" },
    }, {
      { name = "buffer" },
    }),
  })

  cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = { { name = "buffer" } },
  })

  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }),
  })

  local ok_ap, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
  if ok_ap then
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end
end

-------------
---- LSP ----
-------------
local ok_lsp, lspconfig = pcall(require, "lspconfig")
if ok_lsp then
  vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
  })

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local ok_cmp_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if ok_cmp_lsp then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end

  local on_attach = function(_, bufnr)
    local map = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
    end
    map("<leader>d", vim.diagnostic.open_float, "Diagnostic float")
    map("gd", vim.lsp.buf.definition, "Definition")
    map("K", vim.lsp.buf.hover, "Hover")
    map("<leader>rn", vim.lsp.buf.rename, "Rename")
    map("<leader>ca", vim.lsp.buf.code_action, "Code action")
  end

  local function setup(server, opts)
    opts = opts or {}
    opts.on_attach = on_attach
    opts.capabilities = capabilities
    lspconfig[server].setup(opts)
  end

  local candidates = {
    lua_ls        = "lua-language-server",
    pyright       = "pyright",
    rust_analyzer = "rust-analyzer",
    gopls         = "gopls",
    clangd        = "clangd",
    ts_ls         = "typescript-language-server",
    nil_ls        = "nil",
    bashls        = "bash-language-server",
    yamlls        = "yaml-language-server",
    jsonls        = "vscode-json-language-server",
    html          = "vscode-html-language-server",
    cssls         = "vscode-css-language-server",
    marksman      = "marksman",
    taplo         = "taplo",
    dockerls      = "docker-langserver",
  }

  for server, bin in pairs(candidates) do
    if vim.fn.executable(bin) == 1 and lspconfig[server] then
      -- lua_ls настраиваем отдельно ниже
      if server ~= "lua_ls" then
        setup(server)
      end
    end
  end

  if vim.fn.executable("lua-language-server") == 1 and lspconfig.lua_ls then
    setup("lua_ls", {
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      },
    })
  end
else
  vim.notify("nvim-lspconfig not found", vim.log.levels.WARN)
end

-------------------------------
---- nvim-highlight-colors ----
-------------------------------
local ok_hc, hc = pcall(require, "nvim-highlight-colors")
if ok_hc then
  hc.setup({
    render = "background",
    enable_hex = true,
    enable_short_hex = true,
    enable_rgb = true,
    enable_hsl = true,
    enable_ansi = true,
    enable_hsl_without_function = true,
    enable_named_colors = true,
    enable_tailwind = false,
  })
end

-------------------
---- toggleterm ----
-------------------
local ok_tt, toggleterm = pcall(require, "toggleterm")
if ok_tt then
  toggleterm.setup({
    -- open_mapping с <leader> капризничает; бинд ниже надёжнее
    open_mapping = [[<c-\>]],
    direction = "float",
    start_in_insert = true,
    shade_terminals = true,
    float_opts = {
      border = "curved",
    },
  })
end

-------------------------
------(  Keymaps  )------
-------------------------
local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

map("n", "<leader>w", "<cmd>w!<CR>", "Save")
map("n", "<leader>W", "<cmd>w!<CR>", "Write (force)")
map("n", "<leader>q", "<cmd>q<CR>", "Quit")
map("n", "<leader>Q", "<cmd>q!<CR>", "Quit force")
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", "Explorer")

map({ "n", "t" }, "<leader>t", "<cmd>ToggleTerm<CR>", "Toggle terminal")
map({ "n", "t" }, "<C-\\>", "<cmd>ToggleTerm<CR>", "Toggle terminal")

map("t", "<Esc>", [[<C-\><C-n>]], "Terminal normal mode")
