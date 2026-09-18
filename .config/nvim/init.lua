-- Modifier for two classes of shortcuts.
-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim.
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

require("config.lazy")

-- Setup plugin management with lazy.nvim.
require("lazy").setup({
	spec = {
		-- Import plugin specs from the plugins module.
		{ import = "plugins" },
		{ "cespare/vim-toml" },
		{ "chrisbra/NrrwRgn" },
		{ "chriskempson/base16-vim" },
		{ "eigenfoo/stan-vim" },
		{ "igankevich/mesonic" },
		{ "jparise/vim-graphql" },
		{ "junegunn/vim-easy-align" },
		{ "lervag/vimtex" },
		-- { "mattn/emmet-vim" },
		{ "MaxMEllon/vim-jsx-pretty" },
		{ "mechatroner/rainbow_csv" },
		{ "mileszs/ack.vim" },
		{ "pangloss/vim-javascript" },
		{ "plasticboy/vim-markdown" },
		{ "preservim/nerdcommenter" },
		{ "rust-lang/rust.vim" },
		{ "scrooloose/nerdtree" },
		{ "vim-python/python-syntax" },
		{ "vmchale/dhall-vim" },
		{ "wgwoods/vim-systemd-syntax" },
		{ "whybin/alloy.vim" },
	},
	-- Automatically check for plugin updates.
	checker = {
		enabled = true,
		-- Check for updated once a week.
		frequency = 60 * 60 * 24 * 7,
	},
})

vim.cmd.source("~/.config/nvim/old_init.vim")

require("user.options")
require("user.keymaps")

-- ----------------------------------------------------------------------------------
-- Diagnostic and LSP configuration.
-- ----------------------------------------------------------------------------------
vim.o.updatetime = 250
vim.diagnostic.config({
	virtual_text = false,
})

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
	group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
	callback = function()
		vim.diagnostic.open_float(nil, { focus = false })
	end,
})

-- vim.lsp.config["air"] = {
-- 	on_attach = function(_, bufnr)
-- 		vim.api.nvim_create_autocmd("BufWritePre", {
-- 			buffer = bufnr,
-- 			callback = function()
-- 				vim.lsp.buf.format()
-- 			end,
-- 		})
-- 	end,
-- }

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then
			return
		end

		if client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = false })
		end
	end,
})

-- ----------------------------------------------------------------------------------
-- Plugins configuration.
-- ----------------------------------------------------------------------------------
-- Assume CSV files come with headers by default.
vim.g.rbql_with_headers = true
-- Allow comments in CSV files.
vim.g.rainbow_comment_prefix = "#"

-- Airline config.
vim.g.airline_extensions = {
	whitespace = {
		enabled = false,
	},
}

if vim.g.airline_symbols == nil then
	vim.g.airline_symbols = {}
end

-- Unicode symbols
vim.g.airline_left_sep = ""
vim.g.airline_left_alt_sep = ""
vim.g.airline_right_sep = ""
vim.g.airline_right_alt_sep = ""
vim.g.airline_symbols.branch = "⭠"
vim.g.airline_symbols.linenr = ""
vim.g.airline_symbols.modified = "+"
vim.g.airline_symbols.paste = "ρ"
vim.g.airline_symbols.readonly = "⭤"
vim.g.airline_symbols.space = " "
vim.g.airline_symbols.whitespace = "Ξ"

-- Ignore __pycache__ directories in NERDTree listings.
vim.cmd([[ let g:NERDTreeIgnore += ["^__pycache__$"] ]])

local function run(cmd, stdin)
	local res = vim.system(cmd, { stdin = stdin, text = true }):wait()
	if res.code ~= 0 then
		error(("%s failed: %s"):format(cmd[1], res.stderr or ""))
	end
	return res.stdout
end

-- Render the current markdown buffer as a man page in a scratch split.
-- Render Markdown buffer as a man page inside NeoVim.
vim.api.nvim_create_user_command("MdMan", function()
	local src = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
	local width = math.max(40, vim.o.columns - 4)

	local groff_src = run({ "pandoc", "-s", "-f", "markdown", "-t", "man" }, src)
	local rendered = run({ "groff", "-t", "-man", "-Tutf8", ("-rLL=%dn"):format(width) }, groff_src)

	vim.cmd("botright vnew")
	vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(rendered, "\n", { plain = true }))
	vim.cmd("Man!") -- interpret current buffer as a man page; sets ft=man, nomodifiable, highlighting
end, { desc = "Render markdown buffer as a man page via pandoc+groff" })

-- Increase conceallevel to 2 when entering an Obsidian note.
-- Drop to 0 when editing a regular Markdown file.
---@param buf integer
---@return boolean
local function in_obsidian_vault(buf)
	local name = vim.api.nvim_buf_get_name(buf)
	if name == "" then
		return false
	end
	if vim.fs.root(buf, ".obsidian") then
		return true
	end
	local obsidian_roots = require("obsidian_vaults").roots
	local path = vim.fs.normalize(vim.uv.fs_realpath(name) or name)
	return vim.iter(obsidian_roots):any(function(root)
		return path == root or vim.startswith(path, root .. "/")
	end)
end

vim.api.nvim_create_autocmd({ "BufWinEnter", "BufEnter" }, {
	group = vim.api.nvim_create_augroup("md-conceal", { clear = true }),
	callback = function(ev)
		if vim.bo[ev.buf].filetype ~= "markdown" then
			return
		end
		vim.wo[0].conceallevel = in_obsidian_vault(ev.buf) and 2 or 0
	end,
})

-- Fix highlighting of selected row in completion dropdown.
vim.api.nvim_set_hl(0, "PmenuSel", {
	fg = "#f5f5f5",
	bg = "#333333",
	bold = true,
})
