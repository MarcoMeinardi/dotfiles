return {
	{
		"nvim-telescope/telescope.nvim",
		tags = "0.1.1",
		dependencies = {
			"nvim-lua/plenary.nvim"
		},
		keys = {
			{
				"<leader>ff",
				function() require("telescope.builtin").find_files() end,
				mode = { "n", "v" }
			},
			{
				"<leader>fs",
				function() require("telescope.builtin").live_grep() end,
				mode = { "n", "v" }
			},
			{
				"<leader>tg",
				function() require("telescope.builtin").tags({ ctags_file = ".ctags" }) end,
				mode = { "n", "v" }
			},
			{
				"<leader>man",
				function() require("telescope.builtin").man_pages() end,
				mode = { "n", "v" }
			},
			{
				"<leader>old",
				function() require("telescope.builtin").oldfiles() end,
				mode = { "n", "v" }
			}
		}
	}
}
