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
	}
}
