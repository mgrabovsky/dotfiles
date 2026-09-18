return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		-- "L3M0N4D3/LuaSnip",
		-- "saadparwaiz1/cmp_luasnip",
	},
	config = function()
		local has_words_before = function()
			unpack = unpack or table.unpack
			local line, col = unpack(vim.api.nvim_win_get_cursor(0))
			return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)
		end

		-- local luasnip = require("luasnip")
		local cmp = require("cmp")
		cmp.setup({
			completion = { autocomplete = false },
			-- snippet = {
			-- 	expand = function(args)
			-- 		luasnip.lsp_expand(args.body)
			-- 	end
			-- },
			mapping = cmp.mapping.preset.insert({
				["<C-n>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					-- elseif luasnip.expand_or_jumpable() then
					-- 	luasnip.expand_or_jump()
					elseif has_words_before() then
						cmp.complete()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<C-p>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					-- elseif luasnip.jumpable(-1) then
					-- 	luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
				["<Esc>"] = cmp.mapping.abort(),
				["<Tab>"] = cmp.mapping.confirm({ select = true }),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
			}),
			sources = {
				{ name = "nvim_lsp" },
				-- { name = "luasnip" },
			},
		})
	end,
}
