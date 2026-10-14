vim.opt.termguicolors = true
vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then vim.cmd("syntax reset") end
vim.g.colors_name = "matugen"

local c = {
  text     = "#e6e3d5",
  base     = "#14140c",
  mantle   = "#1c1c14",
  surface0 = "#2b2a22",
  surface1 = "#36352c",
  overlay  = "#939182",
  blue     = "#bfecd8",
  on_blue  = "#323200",
  green    = "#cac7b6",
  mauve    = "#a4d0bd",
  on_mauve = "#0b372a",
  red      = "#ffb4ab",
  pmenu    = "#202018",
  search   = "#494900",
  on_search = "#e8e78f",
  comment = "#48473a",
  string = "#254e40",
  func = "#616118",
  numbers = "#cbcb76",
  error = "#93000a",
  warn = "#bfecd8",
  keyword = "#bfecd8",
  variable = "#cbcb76",
  type = "#616118",

}

local hl = function(g, o) vim.api.nvim_set_hl(0, g, o) end

hl("Comment",    { fg = c.overlay, italic = true })
hl("String",     { fg = c.string })
hl("Number",     { fg = c.numbers })
hl("Boolean",    { fg = c.mauve })
hl("Constant",   { fg = c.mauve })
hl("Function",   { fg = c.func })
hl("Keyword",    { fg = c.keyword })
hl("Statement",  { fg = c.mauve })
hl("Operator",   { fg = c.blue })
hl("Type",       { fg = c.type })
hl("Identifier", { fg = c.text })
hl("PreProc",    { fg = c.mauve })
hl("Special",    { fg = c.mauve })
hl("Todo",       { fg = c.on_blue, bg = c.blue, bold = true })
hl("Error",      { fg = c.error })


-- Интерфейс
hl("Normal",       { fg = c.text, bg = c.base })
hl("NormalNC",     { fg = c.text, bg = c.base })
hl("NormalFloat",  { fg = c.text, bg = c.mantle })
hl("FloatBorder",  { fg = c.overlay, bg = c.mantle })
hl("Pmenu",        { fg = c.text, bg = c.pmenu })
hl("PmenuSel",     { fg = c.on_blue, bg = c.blue, bold = true })
hl("CursorLine",   { bg = c.surface0 })
hl("CursorLineNr", { fg = c.blue, bold = true })
hl("LineNr",       { fg = c.overlay })
hl("Visual",       { bg = c.surface1 })
hl("Search",       { fg = c.on_search, bg = c.search })
hl("IncSearch",    { fg = c.on_blue, bg = c.blue })
hl("StatusLine",   { fg = c.text, bg = c.surface0 })
hl("StatusLineNC", { fg = c.overlay, bg = c.mantle })
hl("WinSeparator", { fg = c.surface0 })
hl("TabLine",      { fg = c.overlay, bg = c.mantle })
hl("TabLineSel",   { fg = c.text, bg = c.base, bold = true })
hl("TabLineFill",  { bg = c.mantle })
hl("SignColumn",   { bg = c.base })
hl("Folded",       { fg = c.overlay, bg = c.surface0 })
hl("Directory",    { fg = c.blue })
hl("Title",        { fg = c.mauve, bold = true })
hl("MatchParen",   { fg = c.mauve, bg = c.surface1, bold = true })
hl("NonText",      { fg = c.surface1 })


hl("ModeMsg",    { fg = c.green, bold = true })   -- "-- ВСТАВКА --" и т.д.
hl("MsgArea",    { fg = c.text, bg = c.base })    -- область командной строки
hl("MoreMsg",    { fg = c.blue, bold = true })    -- "-- Продолжение --"
hl("Question",   { fg = c.green })                -- вопросы типа "да/нет"
hl("WarningMsg", { fg = c.mauve })
hl("ErrorMsg",   { fg = c.red })

-- Treesitter
hl("@comment",          { link = "Comment" })
hl("@string",           { link = "String" })
hl("@number",           { link = "Number" })
hl("@boolean",          { link = "Boolean" })
hl("@constant",         { link = "Constant" })
hl("@function",         { link = "Function" })
hl("@keyword",          { link = "Keyword" })
hl("@operator",         { link = "Operator" })
hl("@type",             { link = "Type" })
hl("@variable",         { fg = c.variable })
hl("@property",         { fg = c.comment })
hl("@punctuation",      { fg = c.overlay })
hl("@tag",              { fg = c.mauve })

-- Диагностика LSP
hl("DiagnosticError", { fg = c.error })
hl("DiagnosticWarn",  { fg = c.warn })
hl("DiagnosticInfo",  { fg = c.blue })
hl("DiagnosticHint",  { fg = c.green })
hl("DiagnosticUnderlineError", { underline = true, sp = c.red })
hl("DiagnosticUnderlineWarn",  { underline = true, sp = c.mauve })

-- Git / diff
hl("GitSignsAdd",    { fg = c.green })
hl("GitSignsChange", { fg = c.blue })
hl("GitSignsDelete", { fg = c.red })
