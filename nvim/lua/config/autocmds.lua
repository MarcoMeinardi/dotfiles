vim.api.nvim_create_autocmd("VimEnter", {
	command = "hi MiniIndentScopeSymbol guifg=#ff8c00"
})

vim.api.nvim_create_autocmd("VimEnter", {
	command = "hi MiniJump gui=bold guifg=none guibg=none"
})

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.cmd("ToggleTerm")
		vim.cmd("ToggleTerm")
	end
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("HighlightYank", {}),
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 100,
		})
	end
})
