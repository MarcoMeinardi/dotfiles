return {
	{
		"phaazon/hop.nvim",
		tags = "v2",
		config = true,
		keys = {
			{
				"<leader>h",
				function()
					require("hop").hint_char2()
				end,
				mode = { "n", "v" }
			}
		}
	}
}
