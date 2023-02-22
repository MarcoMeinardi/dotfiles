vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false

vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8

vim.opt.listchars = { tab = " ->" }
vim.opt.list = true

vim.wo.cursorline = true


vim.g.python3_host_prog = "/usr/bin/python3"

vim.g.gutentags_ctags_tagfile = ".ctags"
vim.g.gutentags_project_root = { ".git", ".root" }
vim.g.gutentags_generate_on_empty_buffer = true

vim.g.copilot_no_tab_map = true
