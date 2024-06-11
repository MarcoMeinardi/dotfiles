local Util = require("util")

local function map(mode, lhs, rhs, opts)
	local keys = require("lazy.core.handler").handlers.keys
	---@cast keys LazyKeysHandler
	-- do not create the keymap if a lazy keys handler exists
	if not keys.active[keys.parse({ lhs, mode = mode }).id] then
		opts = opts or {}
		opts.silent = opts.silent ~= false
		vim.keymap.set(mode, lhs, rhs, opts)
	end
end

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

--keywordprg
map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- toggle options
map("n", "<leader>tw", function() Util.toggle("wrap") end, { desc = "Toggle Word Wrap" })
map("n", "<leader>td", Util.toggle_diagnostics, { desc = "Toggle Diagnostics" })
if vim.lsp.inlay_hint then
	map("n", "<leader>th", function() vim.lsp.inlay_hint(0, nil) end, { desc = "Toggle Inlay Hints" })
end

map({"n", "v", "i"}, "<C-c>", "<Esc>")

map("n", "<leader>ww", vim.cmd.w)
map("n", "<leader>q", vim.cmd.q)
map("n", "<leader>wq", vim.cmd.wq)

map("n", "n", "nzz")
map("n", "N", "Nzz")
map({"n", "v"}, "<C-d>", "<C-d>zz")
map({"n", "v"}, "<C-u>", "<C-u>zz")
map("n", "<C-o>", "<C-o>zz")
map("n", "<C-i>", "<C-i>zz")

map({"n", "v"}, "<leader>y", "\"+y")
map({"n", "v"}, "<leader>Y", "\"+Y")
map("n", "<leader>yy", "\"+yy")
map({"n", "v"}, "<leader>d", "\"_d")
map({"n", "v"}, "<leader>D", "\"_D")
map("n", "<leader>dd", "\"_dd")
map({"n", "v"}, "S", "\"_S")
map({"n", "v"}, "s", "\"_s")
map({"n", "v"}, "x", "\"_x")
map({"n", "v"}, "X", "\"_X")
map("n", "<C-]>", "<C-]>zz")

map("n", "<leader>c", "gcc", { remap = true })
map("v", "<leader>c", "gc", { remap = true })

map("i", "<A-h>", "<Cmd>norm h<CR>")
map("i", "<A-j>", "<Cmd>norm j<CR>")
map("i", "<A-k>", "<Cmd>norm k<CR>")
map("i", "<A-l>", "<Cmd>norm l<CR>")

map({"n", "v"}, "<leader>sa", "<Esc>mmggVG")
