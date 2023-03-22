return {
	{
		"folke/todo-comments.nvim",
		lazy = false,
		config = function()
			vim.api.nvim_set_hl(0, "Todo", {})
			require("todo-comments").setup({
				gui_sytle = {
					fg = "none",
					bg = "none"
				},
				highlight = {
					keyword = "bg",
					after = "",
					before = "",
					pattern = [[.*<(KEYWORDS)\s*:?]],
				},
				search = {
					pattern = [[\b(KEYWORDS)\b]]
				}
			})
		end,
		keys = {
			{
				"<leader>td",
				":TodoTelescope<CR>"
			}
		}
	}
}
