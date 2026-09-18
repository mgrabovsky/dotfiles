return {
	"R-nvim/R.nvim",
	opts = {
		pdfviewer = "evince",
		start_libs = "base,stats,graphics,grDevices,utils,datasets,methods,dplyr,ggplot2,tidyr,readr,purrr,tibble,stringr,forcats",
		r_ls = {
			doc_width = 120,
		},
	},
	branch = "main",
	build = "git submodule update --init --recursive",
}
