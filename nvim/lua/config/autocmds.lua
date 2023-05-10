vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.cmd("ToggleTerm")
		vim.cmd("ToggleTerm")
	end
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("HighlightYank", {}),
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 100
		})
	end
})
