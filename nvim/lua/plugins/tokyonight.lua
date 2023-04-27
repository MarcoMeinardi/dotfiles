return {
	{
		"folke/tokyonight.nvim",
		tags = "main",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				transparent = true,
				hide_inactive_statusline = true,

				styles = {
					floats = "transparent"
				},

				on_highlights = function(hl, c)
					hl.CursorLine = { bg = c.bg_dark }
					hl.StatusLine = { bg = "none" }
					hl.DiagnosticVirtualTextError = { bg = "none", fg = c.error }
					hl.DiagnosticVirtualTextWarn = { bg = "none", fg = c.warning }
					hl.DiagnosticVirtualTextInfo = { bg = "none", fg = c.info }
					hl.DiagnosticVirtualTextHint = { bg = "none", fg = c.hint }
					hl.Whitespace = { fg = "#000000" }
					hl.NonText = { fg = "#000000" }
				end
			})
			vim.cmd.colorscheme("tokyonight")
		end
	}
}
