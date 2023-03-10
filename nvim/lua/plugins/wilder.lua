return {
	{
		"gelguy/wilder.nvim",
		dependencies = {
			"romgrk/fzy-lua-native"
		},
		lazy = false,
		config = function()
			local wilder = require('wilder')
			wilder.setup({modes = {':', '/', '?'}})

			wilder.set_option('pipeline', {
				wilder.branch(
					wilder.python_file_finder_pipeline({
					file_command = function(_, arg)
						if string.find(arg, '.') ~= nil then
							return {'fdfind', '-tf', '-H'}
						else
							return {'fdfind', '-tf'}
						end
					end,
					dir_command = {'fd', '-td'},
					filters = {'cpsm_filter'},
				}),
				wilder.substitute_pipeline({
					pipeline = wilder.python_search_pipeline({
						skip_cmdtype_check = 1,
						pattern = wilder.python_fuzzy_pattern({
							start_at_boundary = 0,
						}),
					}),
				}),
				wilder.cmdline_pipeline({
					fuzzy = 2,
					fuzzy_filter = wilder.lua_fzy_filter(),
				}),
				{
					wilder.check(function(_, x) return x == '' end),
					wilder.history(),
				},
				wilder.python_search_pipeline({
					pattern = wilder.python_fuzzy_pattern({
						start_at_boundary = 0,
					}),
				})
			),
			})

			local highlighters = {
				wilder.pcre2_highlighter(),
				wilder.basic_highlighter(),
			}

			local popupmenu_border_theme = wilder.popupmenu_renderer(
				wilder.popupmenu_border_theme({
					border = 'rounded',
					empty_message = wilder.popupmenu_empty_message_with_spinner(),
					highlighter = highlighters,
					left = {
						wilder.popupmenu_devicons(),
						wilder.popupmenu_buffer_flags({
							flags = ' a + ',
							icons = {['+'] = '', a = '', h = ''},
						}),
					},
				})
			)

			local wildmenu_rendered = wilder.wildmenu_renderer({
				highlighter = highlighters,
			})

			wilder.set_option('renderer', wilder.renderer_mux({
				[':'] = popupmenu_border_theme,
				['/'] = wildmenu_rendered
			}))
		end
	}
}
