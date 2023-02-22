return {
	{
		"akinsho/toggleterm.nvim",
		lazy = false,
		opts = {
			hide_numbers = true,
			autochdir = false,
			start_in_insert = true,
			persist_mode = true,
			direction = "tab",
			open_mapping = "<C-q>",
			auto_scroll = false,
			on_open = function()
				vim.cmd.startinsert()
			end
		}
	}
}
