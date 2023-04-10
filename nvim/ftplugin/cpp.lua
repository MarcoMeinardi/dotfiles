vim.api.nvim_buf_set_option(0, "commentstring", "// %s")

vim.keymap.set("n", "<leader>gpp", "<Cmd>w<CR><Cmd>!g++ -o main % -Wall -Wextra -g3 -std=c++20 -fsanitize=signed-integer-overflow -fsanitize=address<CR>", { noremap = true })
vim.keymap.set("n", "<leader>gpr", "<Cmd>w<CR><Cmd>!g++ -o main % -Wall -Wextra -g3 -std=c++20 -fsanitize=signed-integer-overflow -fsanitize=address && ./main<CR>", { noremap = true })
vim.keymap.set("n", "<leader>gr", "<Cmd>!./main<CR>", { noremap = true })
