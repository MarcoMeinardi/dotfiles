-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("HighlightYank", {}),
	callback = function()
		vim.highlight.on_yank({
		higroup = "IncSearch",
		timeout = 100
	})
	end
})

-- set cwd
vim.api.nvim_create_autocmd({ "VimEnter" }, {
	group = vim.api.nvim_create_augroup("Chdir", {}),
	callback = function()
		vim.cmd.cd(require("util").get_root())
	end
})

-- load keymaps
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	group = vim.api.nvim_create_augroup("SetKeymaps", {}),
	callback = function()
		require("config.keymaps")
	end
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
	group = vim.api.nvim_create_augroup("ResizeSplits", {}),
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("WrapSpell", {}),
	pattern = { "gitcommit", "markdown", "tex" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end
})

-- C/C++/Rust comment
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("C/C++/Rust", {}),
	pattern = { "c", "cpp", "rust" },
	callback = function()
		vim.bo.commentstring = "// %s"
	end
})

-- python noexpandtab
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("Python", {}),
	pattern = { "python" },
	callback = function()
		vim.opt.expandtab = false
	end
})

-- Haskell expandtab (I hato it, but compiler warnings are worse)
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("Haskell", {}),
	pattern = { "haskell" },
	callback = function()
		vim.opt.expandtab = true
	end
})

-- gsls filetype
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	group = vim.api.nvim_create_augroup("GSLS", {}),
	pattern = { "*.vert", "*.frag" },
	callback = function()
		vim.bo.filetype = "glsl"
		vim.bo.syntax = "c"
	end
})
