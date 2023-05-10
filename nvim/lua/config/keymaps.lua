vim.g.mapleader = " "

local opts = { noremap = true, silent = true }
local map = vim.keymap.set

map({"n", "v", "i"}, "<C-c>", "<Esc>", opts)

map("n", "<leader>ww", vim.cmd.w, { noremap = true })
map("n", "<leader>q", vim.cmd.q, { noremap = true})
map("n", "<leader>wq", vim.cmd.wq, { noremap = true })

map("n", "n", "nzz", { noremap = true })
map("n", "N", "Nzz", { noremap = true })
map({"n", "v"}, "<C-d>", "<C-d>zz", opts)
map({"n", "v"}, "<C-u>", "<C-u>zz", opts)
map("n", "<C-o>", "<C-o>zz", opts)
map("n", "<C-i>", "<C-i>zz", opts)

map({"n", "v"}, "<leader>y", "\"+y")
map({"n", "v"}, "<leader>Y", "\"+Y")
map("n", "<leader>yy", "\"+yy")
map({"n", "v"}, "<leader>d", "\"_d", opts)
map({"n", "v"}, "<leader>D", "\"_D", opts)
map("n", "<leader>dd", "\"_dd", opts)
map({"n", "v"}, "<leader>C", "\"_C", opts)
map({"n", "v"}, "x", "\"_x", opts)
map({"n", "v"}, "X", "\"_X", opts)
map("n", "<C-]>", "<C-]>zz", { noremap = true })

map("i", "<A-h>", "<Cmd>norm h<CR>", opts)
map("i", "<A-j>", "<Cmd>norm j<CR>", opts)
map("i", "<A-k>", "<Cmd>norm k<CR>", opts)
map("i", "<A-l>", "<Cmd>norm l<CR>", opts)

map({"n", "v"}, "<leader>sa", "<Esc>ggVG", opts)
map("n", "<leader><leader>", "viw", opts)

map("t", "<Esc>", vim.cmd.stopinsert, { noremap = true })
