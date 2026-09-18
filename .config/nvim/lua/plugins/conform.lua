vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

local js_ts_formatters = { "prettierd", "prettier", stop_after_first = true }

return {
	"stevearc/conform.nvim",
	keys = {
		{
			"<leader>ff",
			function()
				require("conform").format({ async = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	---@module "conform"
	---@type conform.setupOpts
	opts = {
		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback",
		},
		formatters_by_ft = {
			javascript = js_ts_formatters,
			lua = { "stylua" },
			python = { "isort", "black" },
			r = { "air" },
			typescript = js_ts_formatters,
			typescriptreact = js_ts_formatters,
		},
	},
}
