return {
	{
		"echasnovski/mini.nvim",
		lazy = false,
		event = "VeryLazy",
		config = function()
			require("mini.comment").setup({
				mappings = {
					comment = "<leader>c",
					comment_line = "<leader>c",
				}
			})

			require("mini.indentscope").setup({
				draw = {
					delay = 0
				},
				try_as_border = true,
				symbol = "▏"
			})

			require("mini.jump").setup({
				delay = {
					highlight = 0
				}
			})

			require("mini.move").setup()
			vim.api.nvim_set_hl(0, "MiniIndentScopeSymbol", { fg = "#ff8c00" })
			vim.api.nvim_set_hl(0, "MiniJump", { bold = true, fg = "none", bg = "none" })
		end
	}
}
