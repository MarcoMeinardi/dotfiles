return {
	{
		"folke/neodev.nvim"
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
						workspace = {
							checkThirdParty = false
						},
						completion = {
							callSnippet = "Replace"
						}
					}
				}
			})
		end
	}
}
