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
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end
})

-- C/C++ comment, compile and run
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("C/C++", {}),
	pattern = { "c", "cpp" },
	callback = function()
		vim.bo.commentstring = "// %s"

		vim.keymap.set("n", "<leader>gcc", "<Cmd>w<CR><Cmd>!gcc -o main % -Wall -Wextra -g3 -fsanitize=signed-integer-overflow -fsanitize=address<CR>", { noremap = true })
		vim.keymap.set("n", "<leader>gcr", "<Cmd>w<CR><Cmd>!gcc -o main % -Wall -Wextra -g3 -fsanitize=signed-integer-overflow -fsanitize=address && ./main<CR>", { noremap = true })
		vim.keymap.set("n", "<leader>gpp", "<Cmd>w<CR><Cmd>!g++ -o main % -Wall -Wextra -g3 -std=c++20 -fsanitize=signed-integer-overflow -fsanitize=address<CR>", { noremap = true })
		vim.keymap.set("n", "<leader>gpr", "<Cmd>w<CR><Cmd>!g++ -o main % -Wall -Wextra -g3 -std=c++20 -fsanitize=signed-integer-overflow -fsanitize=address && ./main<CR>", { noremap = true })
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
