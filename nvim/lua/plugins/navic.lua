return {
	{
		"SmiteshP/nvim-navic",
		lazy = false,
		config = function()
			local navic = require("nvim-navic")
			local lspconfig = require("lspconfig")

			lspconfig.clangd.setup({
				on_attach = function(client, bufnr)
					navic.attach(client, bufnr)
				end
			})

			function Better_get_location()
				local location = navic.get_location()
				if location == "" then
					return ""
				else
					return " [ " .. location .. " ]"
				end
			end

			function Get_diagnostic_count()
				local output = ""
				local signs = require("lsp-zero.presets").defaults().sign_icons
				for severity = 1, 4 do
					local severity_str = vim.diagnostic.severity[severity]
					local count = #vim.diagnostic.get(0, { severity = severity_str })
					if count > 0 then
						if #output > 0 then
							output = output .. " " .. signs[string.lower(severity_str)] .. count
						else
							output = signs[string.lower(severity_str)] .. count
						end
					end
				end
				if #output > 0 then
					return "[" .. output .. "]"
				else
					return ""
				end
			end


			vim.o.statusline = "%<%f%{%v:lua.Better_get_location()%} %{%v:lua.Get_diagnostic_count()%}%h%m%r %=%-14.(%l,%c%V%) %p%%"
		end
	}
}
