return {
	{
		"folke/zen-mode.nvim",
		opts = {
			plugins = {
				options = {
					enabled = true,
					ruler = true,
					showcmd = true
				}
			}
		},
		keys = {
			{
				"<leader>z",
				vim.cmd.ZenMode,
				mode = { "n", "v" }
			}
		}
	}
}
