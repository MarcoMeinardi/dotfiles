return {
	{
		"folke/neodev.nvim",
		lazy = true
	},

	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			require("neodev").setup()

			local lspconfig = require("lspconfig")

			lspconfig.lua_ls.setup({
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace"
						}
					}
				}
			})
		end
	}
}
