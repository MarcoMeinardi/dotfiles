return {
	{
		"aznhe21/actions-preview.nvim",
		lazy = true,
		config = true,
		opts = {
			diff = {
				ctxlen = 1000
			},
			backend = {
				"telescope"
			},
			telescope = {
				layout_strategy = "horizontal",
				layout_config = {
					prompt_position = "bottom",
					preview_cutoff = 0,
				}
			}
		},
		keys = {
			{
				"<leader>fm",
				function() require("actions-preview").code_actions() end,
				mode = { "n", "v"}
			}
		}
	}
}
