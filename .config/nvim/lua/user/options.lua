-- Use 256 colours in terminal.
vim.opt.termguicolors = true

vim.opt.background = "light"
vim.cmd("colorscheme base16-github")

-- UTF-8 witout byte order mark as the default file encoding.
vim.opt.encoding = "utf-8"
vim.opt.bomb = false

-- Enable hidden buffers.
vim.opt.hidden = true
-- Modern escapes in regular expressions.
vim.opt.magic = true
-- Automatically detect case sensitivity when matching.
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- Incremental search and higlighting.
vim.opt.incsearch = true
vim.opt.hlsearch = true
-- Use spaces by default.
vim.opt.expandtab = true

-- Don't use swap or backup files.
vim.opt.swapfile = false
vim.opt.backup = false
-- Four-space tabs.
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
-- Round indents to multiples of 'shiftwidth'.
vim.opt.shiftround = true
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.copyindent = true
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.conceallevel = 1
vim.o.formatoptions = "crq1j"
-- Use the conform.nvim plugin for code formatting.
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
-- Leave at least 4 lines at the top or bottom when scrolling.
vim.opt.scrolloff = 4
-- Automatically reload changed files.
vim.opt.autoread = true
-- Not word delimiters.
vim.opt.iskeyword:append({ "_", "$", "%", "#" })

vim.opt.textwidth = 85
vim.opt.wrap = true
vim.opt.whichwrap:append({ h = true, l = true })
vim.opt.showmode = true
vim.opt.showcmd = true

-- ----------------------------------------------------------------------------------
-- UI settings
-- ----------------------------------------------------------------------------------

-- Disable mouse use for all modes in terminal.
vim.opt.mouse = ""

vim.opt.history = 1000
vim.opt.undolevels = 1000
vim.opt.title = true
vim.opt.visualbell = true
vim.opt.errorbells = false
-- Don't redraw while executing macros.
-- vim.opt.lazyredraw = true

-- Enhanced command line.
vim.opt.wildmenu = true
vim.opt.wildmode = "full"
vim.opt.wildchar = ("\t"):byte() -- FIXME: Can this be done prettier? Seems to be a Neovim bug.
vim.opt.wildcharm = ("\t"):byte() -- FIXME: Can this be done prettier? Seems to be a Neovim bug.
vim.opt.wildignore:append({
	".git",
	"*.exe",
	"*.jpg",
	"*.jpeg",
	"*.bmp",
	"*.png",
	"*.swp",
	"*.bak",
	"*pyc",
	"*.class",
	"*.o",
	"*.hi",
	"*~",
})
vim.opt.foldcolumn = "1"
vim.opt.cursorline = false
vim.opt.number = false
vim.opt.relativenumber = true
vim.opt.ruler = true
vim.opt.laststatus = 2
vim.opt.shortmess = "aOtT"
vim.opt.complete = { ".", "w", "b", "t", "i" }
-- Don't put two spaces after ., ! and ? when formatting with gq, J, etc.
vim.opt.joinspaces = false
