return {
	{
		"VonHeikemen/lsp-zero.nvim",
		dependencies = {
			-- LSP Support
			{"neovim/nvim-lspconfig"},
			{"williamboman/mason.nvim"},
			{"williamboman/mason-lspconfig.nvim"},

			-- Autocompletion
			{"hrsh7th/nvim-cmp"},
			{"hrsh7th/cmp-buffer"},
			{"hrsh7th/cmp-path"},
			{"saadparwaiz1/cmp_luasnip"},
			{"hrsh7th/cmp-nvim-lsp"},
			{"hrsh7th/cmp-nvim-lua"},

			-- Snippets
			{"L3MON4D3/LuaSnip"},
			{"rafamadriz/friendly-snippets"},
		},
		lazy = false,
		config = function()
			local lsp = require("lsp-zero")
			lsp.preset("recommended")


			local cmp = require("cmp")
			local cmp_select = { behavior = cmp.SelectBehavior.Select }
			local cmp_mappings = lsp.defaults.cmp_mappings({
				["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-j>"] = cmp.mapping.select_next_item(cmp_select),

				["<M-q>"] = cmp.mapping(function()
					vim.api.nvim_feedkeys(vim.fn["copilot#Accept"](vim.api.nvim_replace_termcodes("<Tab>", true, true, true)), "n", true)
				end)
			})
			cmp_mappings["<Tab>"] = nil
			cmp_mappings["<S-Tab>"] = nil
			cmp_mappings["<CR>"] = nil

			lsp.setup_nvim_cmp({
				mapping = cmp_mappings
			})

			lsp.setup()

			local telescope = require("telescope.builtin")
			vim.lsp.handlers["textDocument/references"] = telescope.lsp_references
			vim.lsp.handlers["textDocument/definition"] = telescope.lsp_definitions
			vim.lsp.handlers["textDocument/implementation"] = telescope.lsp_implementations

			lsp.set_sign_icons({
				error = '✘',
				warn = '▲',
				hint = '⚑',
				info = '»'
			})

			vim.diagnostic.config({ virtual_text = true })
		end,
		keys = {
			{
				"<leader>fm",
				vim.lsp.buf.code_action,
				mode = { "n", "v"}
			},
			{
				"<leader>rn",
				vim.lsp.buf.rename,
				mode = { "n", "v"}
			},
			{
				"<leader>ls",
				vim.diagnostic.disable,
				mode = { "n", "v"}
			},
			{
				"<Plug>(vimrc:copilot-dummy-map)",
				"copilot#Accept('')",
				mode = { "i" }
			}
		}
	}
}
