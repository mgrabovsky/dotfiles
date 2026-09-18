return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	config = function()
		-- Enable treesitter highlighting and indentation for supported filetypes
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local ft = vim.bo[args.buf].filetype
				-- Skip filetypes managed by rainbow_csv
				if ft:match("^csv") or ft:match("^tsv") or ft:match("^rcsv") then
					return
				end
				local lang = vim.treesitter.language.get_lang(ft)
				if
					lang
					and #vim.api.nvim_get_runtime_file("queries/" .. lang .. "/highlights.scm", true) > 0
				then
					vim.treesitter.start(args.buf)
					vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				else
					vim.bo[args.buf].syntax = "ON"
				end
			end,
		})

		-- Disable treesitter indent for R (known to be buggy)
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "r",
			callback = function()
				vim.bo.indentexpr = ""
			end,
		})

		-- Incremental selection via built-in treesitter node selection
		local select = require("vim.treesitter._select")
		local map = vim.keymap.set
		map("n", "<C-n>", function()
			select.select_child(vim.v.count1)
		end, { desc = "Init treesitter selection" })
		map("v", "<C-n>", function()
			select.select_parent(vim.v.count1)
		end, { desc = "Expand treesitter selection" })
		map("v", "<C-p>", function()
			select.select_child(vim.v.count1)
		end, { desc = "Shrink treesitter selection" })
		map("v", "<C-l>", function()
			select.select_next(vim.v.count1)
		end, { desc = "Select next sibling node" })
		map("v", "<C-h>", function()
			select.select_prev(vim.v.count1)
		end, { desc = "Select previous sibling node" })
	end,
}
