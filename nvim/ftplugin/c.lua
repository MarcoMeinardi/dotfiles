vim.api.nvim_buf_set_option(0, "commentstring", "// %s")

vim.keymap.set("n", "<leader>gcc", "<Cmd>w<CR><Cmd>!gcc -o main % -Wall -Wextra -g3 -fsanitize=signed-integer-overflow -fsanitize=address<CR>", { noremap = true })
vim.keymap.set("n", "<leader>gr", "<Cmd>!./main<CR>", { noremap = true })
