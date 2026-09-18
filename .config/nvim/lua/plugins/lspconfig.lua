return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
	},
	config = function()
		-- NOTE: Configure LSPs first, then enable.
		vim.lsp.config("ty", {
			settings = {
				ty = {
					completions = { autoImport = true },
				},
			},
		})

		vim.lsp.enable("eslint")
		vim.lsp.enable("ts_ls")
		vim.lsp.enable("ty")
	end,
	opts = {
		servers = { "eslint", "ts_ls", "ty" },
	},
}
