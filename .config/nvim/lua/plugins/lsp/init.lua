return {
	-- lspconfig
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "folke/lazydev.nvim" },
			"mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			{
				"hrsh7th/cmp-nvim-lsp",
				cond = function()
					return require("util").has("nvim-cmp")
				end
			}
		},
		---@class PluginLspOpts
		opts = {
			-- options for vim.diagnostic.config()
			diagnostics = {
				underline = true,
				update_in_insert = false,
				virtual_text = {
					spacing = 4,
					source = "if_many",
					prefix = "●"
					-- this will set set the prefix to a function that returns the diagnostics icon based on the severity
					-- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
					-- prefix = "icons",
				},
				severity_sort = true,
				float = { border = "rounded" }
			},
			-- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
			-- Be aware that you also will need to properly configure your LSP server to
			-- provide the inlay hints.
			inlay_hints = {
				enabled = false
			},
			-- add any global capabilities here
			capabilities = {},
			-- LSP Server Settings
			---@type lspconfig.options
			servers = {
				lua_ls = {
					-- mason = false, -- set to false if you don't want this server to be installed with mason
					-- Use this to add any additional keymaps
					-- for specific lsp servers
					---@type LazyKeys[]
					-- keys = {},
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
				},
				clangd = {
					cmd = {
						"clangd",
						"--background-index",
						"--clang-tidy",
						"--header-insertion=iwyu",
						"--completion-style=detailed",
						"--function-arg-placeholders",
						"--fallback-style=llvm"
					},
					init_options = {
						usePlaceholders = true,
						completeUnimported = true,
						clangdFileStatus = true
					}
				}
			},
			-- you can do any additional lsp server setup here
			-- return true if you don't want this server to be setup with lspconfig
			---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
			setup = {
				-- example to setup with typescript.nvim
				-- tsserver = function(_, opts)
				--   require("typescript").setup({ server = opts })
				--   return true
				-- end,
				-- Specify * to use this function as a fallback for any server
				-- ["*"] = function(server, opts) end,
			},
		},
		---@param opts PluginLspOpts
		config = function(_, opts)
			local Util = require("util")

			-- setup keymaps
			Util.on_attach(function(client, buffer)
				require("plugins.lsp.keymaps").on_attach(client, buffer)
			end)

			local register_capability = vim.lsp.handlers["client/registerCapability"]

			vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
				local ret = register_capability(err, res, ctx)
				local client_id = ctx.client_id
				---@type lsp.Client
				local client = vim.lsp.get_client_by_id(client_id)
				local buffer = vim.api.nvim_get_current_buf()
				require("plugins.lsp.keymaps").on_attach(client, buffer)
				return ret
			end

			-- diagnostics
			local diagnostic_icons = {
				Error = '✘',
				Warn = '▲',
				Hint = '⚑',
				Info = '»'
			}
			for name, icon in pairs(diagnostic_icons) do
				name = "DiagnosticSign" .. name
				vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
			end

			local inlay_hint = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint

			if opts.inlay_hints.enabled and inlay_hint then
				Util.on_attach(function(client, buffer)
					if client.supports_method("textDocument/inlayHint") then
						inlay_hint(buffer, true)
					end
				end)
			end

			if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
				opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
				or function(diagnostic)
					for d, icon in pairs(diagnostic_icons) do
						if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
							return icon
						end
					end
				end
			end

			vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

			local servers = opts.servers
			local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				has_cmp and cmp_nvim_lsp.default_capabilities() or {},
				opts.capabilities or {}
			)

			local function setup(server)
				local server_opts = vim.tbl_deep_extend("force", {
					capabilities = vim.deepcopy(capabilities),
				}, servers[server] or {})

				if opts.setup[server] then
					if opts.setup[server](server, server_opts) then
						return
					end
				elseif opts.setup["*"] then
					if opts.setup["*"](server, server_opts) then
						return
					end
				end
				require("lspconfig")[server].setup(server_opts)
			end

			-- get all the servers that are available through mason-lspconfig
			local have_mason, mlsp = pcall(require, "mason-lspconfig")
			local all_mslp_servers = {}
			if have_mason then
				all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
			end

			local ensure_installed = {} ---@type string[]
			for server, server_opts in pairs(servers) do
				if server_opts then
					server_opts = server_opts == true and {} or server_opts
					-- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
					if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
						setup(server)
					else
						ensure_installed[#ensure_installed + 1] = server
					end
				end
			end

			if have_mason then
				mlsp.setup({ ensure_installed = ensure_installed, handlers = { setup } })
			end
		end
	},

	-- formatters
	{
		"nvimtools/none-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "mason.nvim" },
		opts = function()
			return {
				root_dir = require("null-ls.utils").root_pattern(".root", ".git")
			}
		end
	},

	  {
		  "folke/lazydev.nvim",
		  ft = "lua", -- only load on lua files
		  opts = {
			  library = {
				  -- See the configuration section for more details
				  -- Load luvit types when the `vim.uv` word is found
				  { path = "luvit-meta/library", words = { "vim%.uv" } },
			  },
		  },
	  },
	  {
		  "Bilal2453/luvit-meta",
		  lazy = true
	  },

	-- cmdline tools and lsp servers
	{

		"williamboman/mason.nvim",
		cmd = "Mason",
		build = ":MasonUpdate",
		config = true
	},

	{
		"petRUShka/vim-sage",
		event = "BufEnter",
		lazy = false
	}
}
