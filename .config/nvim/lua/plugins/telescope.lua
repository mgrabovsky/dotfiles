return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "master",
		dependencies = { "nvim-lua/plenary.nvim" },
		-- cmd = "Telescope",
		keys = {
			{ "<C-b>", "<cmd>Telescope buffers<CR>", desc = "Find bufers" },
			{ "<C-g>", "<cmd>Telescope git_files<CR>", desc = "Find files (Git root)" },
			{ "<C-p>", "<cmd>Telescope find_files<CR>", desc = "Find files (current directory)" },
			{ "<C-s>", "<cmd>Telescope lsp_document_symbols<CR>", desc = "Search document symbols" },
			{ "<leader>ga", "<cmd>Telescope live_grep<CR>", desc = "Search project" },
			{ "<leader>sd", "<cmd>Telescope lsp_document_symbols<CR>", desc = "Search document symbols" },
			{ "<leader>sw", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", desc = "Search workspace symbols" },
		},
		opts = {
			defaults = {
				mappings = {
					i = {
						["<esc>"] = require("telescope.actions").close,
					},
				},
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
		},
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
		config = function()
			require("telescope").load_extension("fzf")
		end,
	},
}
