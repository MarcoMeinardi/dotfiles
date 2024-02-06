local Util = require("lazy.core.util")

local M = {}

M.root_patterns = { ".git", ".root" }

---@param on_attach fun(client, buffer)
function M.on_attach(on_attach)
	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)
			local buffer = args.buf
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			on_attach(client, buffer)
		end,
	})
end

---@param plugin string
function M.has(plugin)
	return require("lazy.core.config").spec.plugins[plugin] ~= nil
end

function M.fg(name)
	---@type {foreground?:number}?
	local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name }) or vim.api.nvim_get_hl_by_name(name, true)
	local fg = hl and hl.fg or hl.foreground
	return fg and { fg = string.format("#%06x", fg) }
end

---@param fn fun()
function M.on_very_lazy(fn)
	vim.api.nvim_create_autocmd("User", {
		pattern = "VeryLazy",
		callback = function()
			fn()
		end,
	})
end

---@param name string
function M.opts(name)
	local plugin = require("lazy.core.config").plugins[name]
	if not plugin then
		return {}
	end
	local Plugin = require("lazy.core.plugin")
	return Plugin.values(plugin, "opts", false)
end

-- returns the project root directory
---@return string
function M.get_root()
	local path = vim.fn.expand("#:p")
	if path == "" then
		path = vim.fn.expand("%:p:h")
	end
	local root_file = vim.fs.find({ ".git", ".root" }, { path = path, upward = true })[1]
	if root_file then
		local root_dir = vim.fs.dirname(root_file)
		return root_dir
	else
		if path:sub(-1) == '/' then
			return path
		else
			return vim.fn.expand("%:p:h")
		end
	end
end

-- this will return a function that calls telescope.
-- cwd will default to util.get_root
-- for `files`, git_files or find_files will be chosen depending on .git
function M.telescope(builtin, opts)
	local params = { builtin = builtin, opts = opts }
	return function()
		builtin = params.builtin
		opts = params.opts
		if opts ~= nil then
			opts["default_text"] = M.get_selected_text()
		else
			opts = { default_text = M.get_selected_text() }
		end
		opts = vim.tbl_deep_extend("force", { cwd = M.get_root() }, opts)
		if builtin == "files" then
			if vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.git") then
				opts.show_untracked = true
				builtin = "git_files"
			else
				builtin = "find_files"
			end
		end

		require("telescope.builtin")[builtin](opts)
	end
end

---@param silent boolean?
---@param values? {[1]:any, [2]:any}
function M.toggle(option, silent, values)
	if values then
		if vim.opt_local[option]:get() == values[1] then
			vim.opt_local[option] = values[2]
		else
			vim.opt_local[option] = values[1]
		end
		return Util.info("Set " .. option .. " to " .. vim.opt_local[option]:get(), { title = "Option" })
	end
	vim.opt_local[option] = not vim.opt_local[option]:get()
	if not silent then
		if vim.opt_local[option]:get() then
			Util.info("Enabled " .. option, { title = "Option" })
		else
			Util.warn("Disabled " .. option, { title = "Option" })
		end
	end
end

local enabled = true
function M.toggle_diagnostics()
	enabled = not enabled
	if enabled then
		vim.diagnostic.enable()
		Util.info("Enabled diagnostics", { title = "Diagnostics" })
	else
		vim.diagnostic.disable()
		Util.warn("Disabled diagnostics", { title = "Diagnostics" })
	end
end

-- delay notifications till vim.notify was replaced or after 500ms
function M.lazy_notify()
	local notifs = {}
	local function temp(...)
		table.insert(notifs, vim.F.pack_len(...))
	end

	local orig = vim.notify
	vim.notify = temp

	local timer = vim.loop.new_timer()
	local check = vim.loop.new_check()

	local replay = function()
		timer:stop()
		check:stop()
		if vim.notify == temp then
			vim.notify = orig -- put back the original notify if needed
		end
		vim.schedule(function()
			---@diagnostic disable-next-line: no-unknown
			for _, notif in ipairs(notifs) do
				vim.notify(vim.F.unpack_len(notif))
			end
		end)
	end

	-- wait till vim.notify has been replaced
	check:start(function()
		if vim.notify ~= temp then
			replay()
		end
	end)
	-- or if it took more than 500ms, then something went wrong
	timer:start(500, 0, replay)
end

function M.lsp_get_config(server)
	local configs = require("lspconfig.configs")
	return rawget(configs, server)
end

---@param server string
---@param cond fun( root_dir, config): boolean
function M.lsp_disable(server, cond)
	local util = require("lspconfig.util")
	local def = M.lsp_get_config(server)
	def.document_config.on_new_config = util.add_hook_before(def.document_config.on_new_config, function(config, root_dir)
		if cond(root_dir, config) then
			config.enabled = false
		end
	end)
end

---@param name string
---@param fn fun(name:string)
function M.on_load(name, fn)
	local Config = require("lazy.core.config")
	if Config.plugins[name] and Config.plugins[name]._.loaded then
		vim.schedule(function()
			fn(name)
		end)
	else
		vim.api.nvim_create_autocmd("User", {
			pattern = "LazyLoad",
			callback = function(event)
				if event.data == name then
					fn(name)
					return true
				end
			end,
		})
	end
end

---@param from string
---@param to string
function M.on_rename(from, to)
	local clients = vim.lsp.get_active_clients()
	for _, client in ipairs(clients) do
		if client:supports_method("workspace/willRenameFiles") then
			local resp = client.request_sync("workspace/willRenameFiles", {
				files = {
					{
						oldUri = vim.uri_from_fname(from),
						newUri = vim.uri_from_fname(to),
					},
				},
			}, 1000)
			if resp and resp.result ~= nil then
				vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
			end
		end
	end
end

function M.get_selected_text()
	local mode = vim.api.nvim_get_mode().mode
	if mode ~= "v" then
		return ""
	end

	local old_reg = vim.fn.getreg("v")
	vim.cmd('noau normal! "vy')
	local selected_text = vim.fn.getreg("v")
	vim.fn.setreg("v", old_reg)
	selected_text = string.gsub(selected_text, "\n", "")

	return selected_text
end

return M
