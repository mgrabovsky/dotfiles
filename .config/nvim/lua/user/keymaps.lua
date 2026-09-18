local map = vim.keymap.set

map("n", ";", ":")

-- Digraphs -- shorcuts for symbols that are usually not so easy to type
-- on a keyboard. Usage: press ^K in insert mode followed by the two
-- characters.
vim.fn.digraph_setlist({
	{ "~~", "≈" },
})

-- Unmap annoying keys.
map({ "i", "n", "v" }, "<left>", "<nop>")
map({ "i", "n", "v" }, "<right>", "<nop>")
map({ "i", "n", "v" }, "<up>", "<nop>")
map({ "i", "n", "v" }, "<down>", "<nop>")
map("n", "Q", "<nop>")

-- Move blockwise using j and k.
map("n", "j", "gj")
map("n", "k", "gk")

-- Moving lines and blocks up and down.
map("n", "<A-j>", "mz:m+<cr>`z")
map("n", "<A-k>", "mz:m-2<cr>`z")
map("v", "<A-j>", ":m'>+<cr>`<my`>mzgv`yo`z")
map("v", "<A-k>", ":m'<-2<cr>`>my`<mzgv`yo`z")

-- Switching between buffers.
map("n", "<right>", "<cmd>bnext<cr>")
map("n", "<left>", "<cmd>bprevious<cr>")

-- Close buffer shortcut.
map("n", "<leader>bc", "<cmd>bdelete!<cr>")

-- Switch to the previously edited buffer.
map("n", "<C-e>", "<cmd>b#<cr>")

-- Toggle line wrapping.
map("n", "<leader>w", "<cmd>setlocal wrap!<cr>")

-- Terminal environment.
map("t", "<esc>", "<C-\\><C-n>")
map("t", "<C-\\><esc>", "<esc>", { remap = false })

-- Switching between windows.
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-c>", "<C-w>c")

-- Clear lastest match highlight.
map("n", "<leader>/", "<cmd>let @/=''<cr>")
-- Shortcuts for quick terminal deployment in a split window.
map("n", "<leader>vt", ":vsplit +term<cr>i")
map("n", "<leader>ht", ":split +term<cr>i")
map("n", "<leader>tR", ":term ~/.local/bin/Rtidy<cr>")

-- Send selection to the previous/alternate window (presumably the REPL) and run it.
-- Send visual selection.
map("v", "<leader>tt", "y<C-w>ppa<cr><C-\\><C-n><C-w>p")
-- Send current line or block/paragraph in normal mode.
map("n", "<leader>tl", "yy<C-w>ppa<cr><C-\\><C-n><C-w>p")
map("n", "<leader>tt", "yap<C-w>ppa<cr><C-\\><C-n><C-w>p")

-- Strip all trailing whitespace.
map("n", "<leader>W", ":%s/\\s\\+$//<cr>:let @/=''<cr>")

-- LSP-related shortcuts.
-- map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
-- map("n", "<leader>ff", vim.lsp.buf.format, { desc = "Format buffer" })
