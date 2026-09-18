return {
	"nvim-telescope/telescope-bibtex.nvim",
	version = "*",
	lazy = true,
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		require("telescope").load_extension("bibtex")
	end,
}
