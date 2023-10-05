return {
	{
		"folke/tokyonight.nvim",
		lazy = true,
		opts = {
			transparent = true,
			hide_inactive_statusline = true,

			styles = {
				floats = "transparent"
			},

			on_highlights = function(hl, c)
				hl.CursorLine = { bg = c.bg_dark }
				hl.StatusLine = { bg = "none" }
				hl.Pmenu = { bg = "none" }
				hl.DiagnosticVirtualTextError = { bg = "none", fg = c.error }
				hl.DiagnosticVirtualTextWarn = { bg = "none", fg = c.warning }
				hl.DiagnosticVirtualTextInfo = { bg = "none", fg = c.info }
				hl.DiagnosticVirtualTextHint = { bg = "none", fg = c.hint }
				hl.NvimTreeNormal = { bg = "none" }
				hl.NvimTreeNormalNC = { bg = "none" }
				hl.IlluminatedWordText = { underline = true }

				hl.Whitespace = { fg = "#000000" }
				hl.NonText = { fg = "#000000" }
			end
		}
	}

}
