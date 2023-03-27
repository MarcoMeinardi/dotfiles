local function get_selected_text()
	local mode = vim.api.nvim_get_mode().mode
	if mode ~= "v" then
		return ""
	end

	local old_reg = vim.fn.getreg("v")
	vim.cmd('noau normal! "vy')
	local selected_text = vim.fn.getreg("v")
	vim.fn.setreg("v", old_reg)
	selected_text = string.gsub(selected_text, "\n", "")

	return selected_text
end

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
				function() require("telescope.builtin").find_files({ default_text = get_selected_text() }) end,
				mode = { "n", "v" }
			},
			{
				"<leader>fs",
				function() require("telescope.builtin").live_grep({ default_text = get_selected_text() }) end,
				mode = { "n", "v" }
			},
			{
				"<leader>bs",
				function() require("telescope.builtin").current_buffer_fuzzy_find({ default_text = get_selected_text() }) end,
				mode = { "n", "v" }
			},
			{
				"<leader>bt",
				function() require("telescope.builtin").current_buffer_tags({ default_text = get_selected_text() }) end,
				mode = { "n", "v" }
			},
			{
				"<leader>tg",
				function() require("telescope.builtin").tags({ ctags_file = ".ctags", default_text = get_selected_text() }) end,
				mode = { "n", "v" }
			},
			{
				"<leader>man",
				function() require("telescope.builtin").man_pages({ default_text = get_selected_text() }) end,
				mode = { "n", "v" }
			},
			{
				"<leader>old",
				function() require("telescope.builtin").oldfiles({ default_text = get_selected_text() }) end,
				mode = { "n", "v" }
			}
		}
	},

	{
		"aaronhallaert/ts-advanced-git-search.nvim",
		config = function()
			require("telescope").load_extension("advanced_git_search")
		end,
		lazy = false,
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"tpope/vim-fugitive",
		},
	}
}
