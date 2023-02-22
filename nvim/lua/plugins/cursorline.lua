return {
	{
		"yamatsum/nvim-cursorline",
		lazy = false,
		opts = {
			cursorline = {
				enable = false
			},
			cursorword = {
				enable = true,
				min_length = 3,
				hl = { underline = true }
			}
		}
	}
}
