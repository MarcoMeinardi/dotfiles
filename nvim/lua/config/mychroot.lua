local my_chroot = function()
	local path = vim.fn.expand("#:p")
	if path == "" then
		path = vim.fn.expand("%:p:h")
	end
	local root_file = vim.fs.find({ ".git", ".root" }, { path = path, upward = true })[1]
	if root_file then
		local root_dir = vim.fs.dirname(root_file)
		vim.cmd.cd(root_dir)
	else
		if path:sub(-1) == '/' then
			vim.cmd.cd(path)
		else
			vim.cmd.cd(vim.fn.expand("%:p:h"))
		end
	end

end

vim.api.nvim_create_autocmd("VimEnter", {
	callback = my_chroot
})
