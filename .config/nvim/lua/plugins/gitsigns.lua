return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		signs = {
			add = { text = "┃" },
			change = { text = "║" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
		},
		on_attach = function(bufnr)
			local gs = require("gitsigns")
			local function map(mode, l, r, desc)
				vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
			end
			map("n", "]h", function()
				if vim.wo.diff then
					-- Standard vim command to jump to the start of the next change
					-- in a diff.
					vim.cmd.normal({ "]c", bang = true })
				else
					gs.nav_hunk("next")
				end
			end, "Next hunk")
			map("n", "[h", function()
				if vim.wo.diff then
					-- Standard vim command to jump to the start of the previous change
					-- in a diff.
					vim.cmd.normal({ "[c", bang = true })
				else
					gs.nav_hunk("prev")
				end
			end, "Prev hunk")
			map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
			map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
			map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
			map("n", "<leader>hb", function()
				gs.blame_line({ full = true })
			end, "Blame line")
			map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
			map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
		end,
	},
}
