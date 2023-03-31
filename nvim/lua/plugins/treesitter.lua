return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = true,
		opts = {
			sync_install = true,
			auto_install = true,

			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			}
		}
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		lazy = false,
		config = function()
			require("treesitter-context").setup({
				mode = "topline",
				separator = "─"
			})
			vim.cmd("highlight clear TreesitterContext")
		end
	}
}
