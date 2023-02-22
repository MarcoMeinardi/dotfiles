return {
	{
		"folke/neodev.nvim",
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
