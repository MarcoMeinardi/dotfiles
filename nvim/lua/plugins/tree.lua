return {
	{
		"nvim-tree/nvim-tree.lua",
		lazy = false,
		config = function()
			require("nvim-tree").setup({
				actions = {
					change_dir = {
						enable = false
					},
					open_file = {
						quit_on_open = true
					}
				}
			})
			vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "none" })
			vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = "none" })
		end,
		keys = {
			{
				"<leader>fe",
				function()
					require("nvim-tree").open_replacing_current_buffer()
				end,
				mode = { "n", "v" }
			}
		}
	}
}
