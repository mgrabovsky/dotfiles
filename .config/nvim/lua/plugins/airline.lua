vim.g.airline_mode_map = {
	["__"] = "---",
	["n"] = " N ",
	["i"] = " I ",
	["R"] = " R ",
	["c"] = " C ",
	["v"] = " V ",
	["V"] = "V·L",
	[""] = "V·B",
	["s"] = " S ",
	["S"] = "S·L",
	[""] = "V·B",
	["t"] = " T ",
}

vim.g.airline_theme = "base16"

return {
	{ "vim-airline/vim-airline" },
	{ "vim-airline/vim-airline-themes" },
}
