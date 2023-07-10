return {
	{
		"iamcco/markdown-preview.nvim",
		lazy = false,
		event = "VeryLazy",
		build = function() vim.fn["mkdp#util#install"]() end,
		keys = {
			{
				"<leader>md",
				vim.cmd.MarkdownPreview
			}
		}
	}
}
