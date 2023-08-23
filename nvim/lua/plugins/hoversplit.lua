return {
	{
		"roobert/hoversplit.nvim",
		lazy = true,
		config = true,
		keys = {
			{
				"<leader>dv",
				function() require('hoversplit').vsplit_remain_focused() end
			},
			{
				"<leader>dh",
				function() require('hoversplit').split_remain_focused() end
			}
		}
	}
}
