return {
	"obsidian-nvim/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	ft = "markdown",
	-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
	-- event = {
	--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
	--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
	--   -- refer to `:h file-pattern` for more examples
	--   "BufReadPre path/to/my-vault/*.md",
	--   "BufNewFile path/to/my-vault/*.md",
	-- },
	dependencies = {
		"nvim-lua/plenary.nvim", -- Required.
		"nvim-telescope/telescope.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	---@module 'obsidian'
	---@type obsidian.config
	opts = {
		checkbox = {
			order = { " ", "x", ">", "~", "!" },
		},
		-- TODO: Remove once we bump to 4.0.0.
		legacy_commands = false,
		picker = {
			name = "telescope.nvim",
		},
		ui = {
			-- Adjustments for non-nerd fonts.
			checkboxes = {
				[" "] = { char = "◻", hl_group = "ObsidianTodo" },
				["x"] = { char = "✔", hl_group = "ObsidianDone" },
				[">"] = { char = "▷", hl_group = "ObsidianRightArrow" },
				["~"] = { char = "～", hl_group = "ObsidianTilde" },
				["!"] = { char = "❗", hl_group = "ObsidianImportant" },
			},
			external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
		},
		workspaces = require("obsidian_vaults").workspaces,
	},
}
