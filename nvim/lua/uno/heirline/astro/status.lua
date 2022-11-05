unoline.status = { hl = {}, init = {}, provider = {}, condition = {}, component = {}, utils = {}, env = {} }
local devicons_avail, devicons = pcall(require, "nvim-web-devicons")

unoline.status.env.modes = {
	["n"] = { "NORMAL", "normal" },
	["no"] = { "OP", "normal" },
	["nov"] = { "OP", "normal" },
	["noV"] = { "OP", "normal" },
	["no"] = { "OP", "normal" },
	["niI"] = { "NORMAL", "normal" },
	["niR"] = { "NORMAL", "normal" },
	["niV"] = { "NORMAL", "normal" },
	["i"] = { "INSERT", "insert" },
	["ic"] = { "INSERT", "insert" },
	["ix"] = { "INSERT", "insert" },
	["t"] = { "TERM", "insert" },
	["nt"] = { "TERM", "insert" },
	["v"] = { "VISUAL", "visual" },
	["vs"] = { "VISUAL", "visual" },
	["V"] = { "LINES", "visual" },
	["Vs"] = { "LINES", "visual" },
	[""] = { "BLOCK", "visual" },
	["s"] = { "BLOCK", "visual" },
	["R"] = { "REPLACE", "replace" },
	["Rc"] = { "REPLACE", "replace" },
	["Rx"] = { "REPLACE", "replace" },
	["Rv"] = { "V-REPLACE", "replace" },
	["s"] = { "SELECT", "visual" },
	["S"] = { "SELECT", "visual" },
	[""] = { "BLOCK", "visual" },
	["c"] = { "COMMAND", "command" },
	["cv"] = { "COMMAND", "command" },
	["ce"] = { "COMMAND", "command" },
	["r"] = { "PROMPT", "inactive" },
	["rm"] = { "MORE", "inactive" },
	["r?"] = { "CONFIRM", "inactive" },
	["!"] = { "SHELL", "inactive" },
	["null"] = { "null", "inactive" },
}

local function pattern_match(str, pattern_list)
	for _, pattern in ipairs(pattern_list) do
		if str:find(pattern) then
			return true
		end
	end
	return false
end

unoline.status.env.buf_matchers = {
	filetype = function(pattern_list)
		return pattern_match(vim.bo.filetype, pattern_list)
	end,
	buftype = function(pattern_list)
		return pattern_match(vim.bo.buftype, pattern_list)
	end,
	bufname = function(pattern_list)
		return pattern_match(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t"), pattern_list)
	end,
}

unoline.status.env.separators = unoline.user_plugin_opts("heirline.separators", {
	none = { "", "" },
	left = { "", "  " },
	right = { "  ", "" },
	center = { "  ", "  " },
	tab = { "", "" },
})

--- Get the highlight background color of the lualine theme for the current colorscheme
-- @param  mode the neovim mode to get the color of
-- @param  fallback the color to fallback on if a lualine theme is not present
-- @return The background color of the lualine theme or the fallback parameter if one doesn't exist
function unoline.status.hl.lualine_mode(mode, fallback)
	local lualine_avail, lualine = pcall(require, "lualine.themes." .. (vim.g.colors_name or "default_theme"))
	local lualine_opts = lualine_avail and lualine[mode]
	return lualine_opts and type(lualine_opts.a) == "table" and lualine_opts.a.bg or fallback
end

--- Get the highlight for the current mode
-- @return the highlight group for the current mode
-- @usage local heirline_component = { provider = "Example Provider", hl = unoline.status.hl.mode },
function unoline.status.hl.mode()
	return { bg = unoline.status.hl.mode_bg() }
end

--- Get the foreground color group for the current mode, good for usage with Heirline surround utility
-- @return the highlight group for the current mode foreground
-- @usage local heirline_component = require("heirline.utils").surround({ "|", "|" }, unoline.status.hl.mode_bg, heirline_component),
function unoline.status.hl.mode_bg()
	return unoline.status.env.modes[vim.fn.mode()][2]
end

--- Get the foreground color group for the current filetype
-- @return the highlight group for the current filetype foreground
-- @usage local heirline_component = { provider = unoline.status.provider.fileicon(), hl = unoline.status.hl.filetype_color },
function unoline.status.hl.filetype_color(self)
	if not devicons_avail then
		return {}
	end
	local _, color = devicons.get_icon_color(
		vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self and self.bufnr or 0), ":t"),
		nil,
		{ default = true }
	)
	return { fg = color }
end

--- An `init` function to build a set of children components for LSP breadcrumbs
-- @param opts options for configuring the breadcrumbs (default: `{ separator = " > ", icon = { enabled = true, hl = false }, padding = { left = 0, right = 0 } }`)
-- @return The Heirline init function
-- @usage local heirline_component = { init = unoline.status.init.breadcrumbs { padding = { left = 1 } } }
function unoline.status.init.breadcrumbs(opts)
	local aerial_avail, aerial = pcall(require, "aerial")
	opts = unoline.default_tbl(
		opts,
		{ separator = " > ", icon = { enabled = true, hl = false }, padding = { left = 0, right = 0 } }
	)
	return function(self)
		local data = aerial_avail and aerial.get_location(true) or {}
		local children = {}
		-- create a child for each level
		for i, d in ipairs(data) do
			local pos = unoline.status.utils.encode_pos(d.lnum, d.col, self.winnr)
			local child = {
				{ provider = string.gsub(d.name, "%%", "%%%%"):gsub("%s*->%s*", "") }, -- add symbol name
				on_click = { -- add on click function
					minwid = pos,
					callback = function(_, minwid)
						local lnum, col, winnr = unoline.status.utils.decode_pos(minwid)
						vim.api.nvim_win_set_cursor(vim.fn.win_getid(winnr), { lnum, col })
					end,
					name = "heirline_breadcrumbs",
				},
			}
			if opts.icon.enabled then -- add icon and highlight if enabled
				table.insert(child, 1, {
					provider = string.format("%s ", d.icon),
					hl = opts.icon.hl and string.format("Aerial%sIcon", d.kind) or nil,
				})
			end
			if #data > 1 and i < #data then
				table.insert(child, { provider = opts.separator })
			end -- add a separator only if needed
			table.insert(children, child)
		end
		if opts.padding.left > 0 then -- add left padding
			table.insert(children, 1, { provider = unoline.pad_string(" ", { left = opts.padding.left - 1 }) })
		end
		if opts.padding.right > 0 then -- add right padding
			table.insert(children, { provider = unoline.pad_string(" ", { right = opts.padding.right - 1 }) })
		end
		-- instantiate the new child
		self[1] = self:new(children, 1)
	end
end

--- An `init` function to build multiple update events which is not supported yet by Heirline's update field
-- @param opts an array like table of autocmd events as either just a string or a table with custom patterns and callbacks.
-- @return The Heirline init function
-- @usage local heirline_component = { init = unoline.status.init.update_events { "BufEnter", { "User", pattern = "LspProgressUpdate" } } }
function unoline.status.init.update_events(opts)
	return function(self)
		if not rawget(self, "once") then
			local clear_cache = function()
				self._win_cache = nil
			end
			for _, event in ipairs(opts) do
				local event_opts = { callback = clear_cache }
				if type(event) == "table" then
					event_opts.pattern = event.pattern
					event_opts.callback = event.callback or clear_cache
					event.pattern = nil
					event.callback = nil
				end
				vim.api.nvim_create_autocmd(event, event_opts)
			end
			self.once = true
		end
	end
end

--- A provider function for the fill string
-- @return the statusline string for filling the empty space
-- @usage local heirline_component = { provider = unoline.status.provider.fill }
function unoline.status.provider.fill()
	return "%="
end

--- A provider function for showing if spellcheck is on
-- @param opts options passed to the stylize function
-- @return the function for outputting if spell is enabled
-- @usage local heirline_component = { provider = unoline.status.provider.spell() }
-- @see unoline.status.utils.stylize
function unoline.status.provider.spell(opts)
	opts = unoline.default_tbl(opts, { str = "", icon = { kind = "Spellcheck" }, show_empty = true })
	return function()
		return unoline.status.utils.stylize(vim.wo.spell and opts.str, opts)
	end
end

--- A provider function for showing if paste is enabled
-- @param opts options passed to the stylize function
-- @return the function for outputting if paste is enabled
-- @usage local heirline_component = { provider = unoline.status.provider.paste() }
-- @see unoline.status.utils.stylize
function unoline.status.provider.paste(opts)
	opts = unoline.default_tbl(opts, { str = "", icon = { kind = "Paste" }, show_empty = true })
	return function()
		return unoline.status.utils.stylize(vim.opt.paste:get() and opts.str, opts)
	end
end

--- A provider function for displaying if a macro is currently being recorded
-- @param opts a prefix before the recording register and options passed to the stylize function
-- @return a function that returns a string of the current recording status
-- @usage local heirline_component = { provider = unoline.status.provider.macro_recording() }
-- @see unoline.status.utils.stylize
function unoline.status.provider.macro_recording(opts)
	opts = unoline.default_tbl(opts, { prefix = "@" })
	return function()
		local register = vim.fn.reg_recording()
		if register ~= "" then
			register = opts.prefix .. register
		end
		return unoline.status.utils.stylize(register, opts)
	end
end

--- A provider function for displaying if a macro is currently being recorded
-- @param opts a prefix before the recording register and options passed to the stylize function
-- @return a function that returns a string of the current recording status
-- @usage local heirline_component = { provider = unoline.status.provider.macro_recording() }
-- @see unoline.status.utils.stylize
function unoline.status.provider.neottest_running(opts)
	opts = unoline.default_tbl(opts, { prefix = "@" })
	return function()
		local register = vim.fn.reg_recording()
		if register ~= "" then
			register = opts.prefix .. register
		end
		return unoline.status.utils.stylize(register, opts)
	end
end

--- A provider function for showing the text of the current vim mode
-- @param opts options for padding the text and options passed to the stylize function
-- @return the function for displaying the text of the current vim mode
-- @usage local heirline_component = { provider = unoline.status.provider.mode_text() }
-- @see unoline.status.utils.stylize
function unoline.status.provider.mode_text(opts)
	local max_length = math.max(table.unpack(vim.tbl_map(function(str)
		return #str[1]
	end, vim.tbl_values(unoline.status.env.modes))))
	return function()
		local text = unoline.status.env.modes[vim.fn.mode()][1]
		if opts.pad_text then
			local padding = max_length - #text
			if opts.pad_text == "right" then
				text = string.rep(" ", padding) .. text
			elseif opts.pad_text == "left" then
				text = text .. string.rep(" ", padding)
			elseif opts.pad_text == "center" then
				text = string.rep(" ", math.floor(padding / 2)) .. text .. string.rep(" ", math.ceil(padding / 2))
			end
		end
		return unoline.status.utils.stylize(text, opts)
	end
end

--- A provider function for showing the percentage of the current location in a document
-- @param opts options passed to the stylize function
-- @return the statusline string for displaying the percentage of current document location
-- @usage local heirline_component = { provider = unoline.status.provider.percentage() }
-- @see unoline.status.utils.stylize
function unoline.status.provider.percentage(opts)
	return function()
		local text = "%p%%"
		local current_line = vim.fn.line(".")
		if current_line == 1 then
			text = "Top"
		elseif current_line == vim.fn.line("$") then
			text = "Bot"
		end
		return unoline.status.utils.stylize(text, opts)
	end
end

--- A provider function for showing the current line and character in a document
-- @param opts options for padding the line and character locations and options passed to the stylize function
-- @return the statusline string for showing location in document line_num:char_num
-- @usage local heirline_component = { provider = unoline.status.provider.ruler({ pad_ruler = { line = 3, char = 2 } }) }
-- @see unoline.status.utils.stylize
function unoline.status.provider.ruler(opts)
	opts = unoline.default_tbl(opts, { pad_ruler = { line = 0, char = 0 } })
	return unoline.status.utils.stylize(string.format("%%%dl:%%%dc", opts.pad_ruler.line, opts.pad_ruler.char), opts)
end

--- A provider function for showing the current location as a scrollbar
-- @param opts options passed to the stylize function
-- @return the function for outputting the scrollbar
-- @usage local heirline_component = { provider = unoline.status.provider.scrollbar() }
-- @see unoline.status.utils.stylize
function unoline.status.provider.scrollbar(opts)
	local sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }
	return function()
		local curr_line = vim.api.nvim_win_get_cursor(0)[1]
		local lines = vim.api.nvim_buf_line_count(0)
		local i = math.floor((curr_line - 1) / lines * #sbar) + 1
		return unoline.status.utils.stylize(string.rep(sbar[i] or "", 2), opts)
	end
end

--- A provider to simply show a cloes button icon
-- @param opts options passed to the stylize function and the kind of icon to use
-- @return return the stylized icon
-- @usage local heirline_component = { provider = unoline.status.provider.close_button() }
-- @see unoline.status.utils.stylize
function unoline.status.provider.close_button(opts)
	opts = unoline.default_tbl(opts, { kind = "BufferClose" })
	return unoline.status.utils.stylize(unoline.get_icon(opts.kind), opts)
end

--- A provider function for showing the current filetype
-- @param opts options passed to the stylize function
-- @return the function for outputting the filetype
-- @usage local heirline_component = { provider = unoline.status.provider.filetype() }
-- @see unoline.status.utils.stylize
function unoline.status.provider.filetype(opts)
	return function(self)
		local buffer = vim.bo[self and self.bufnr or 0]
		return unoline.status.utils.stylize(string.lower(buffer.filetype), opts)
	end
end

--- A provider function for showing the current filename
-- @param opts options for argument to fnamemodify to format filename and options passed to the stylize function
-- @return the function for outputting the filename
-- @usage local heirline_component = { provider = unoline.status.provider.filename() }
-- @see unoline.status.utils.stylize
function unoline.status.provider.filename(opts)
	opts = unoline.default_tbl(opts, {
		fname = function(nr)
			return vim.api.nvim_buf_get_name(nr)
		end,
		modify = ":t",
	})
	return function(self)
		local filename = vim.fn.fnamemodify(opts.fname(self and self.bufnr or 0), opts.modify)
		return unoline.status.utils.stylize((filename == "" and "[No Name]" or filename), opts)
	end
end

--- Get a unique filepath between all buffers
-- @param opts options for function to get the buffer name, a buffer number, max length, and options passed to the stylize function
-- @return path to file that uniquely identifies each buffer
-- @usage local heirline_component = { provider = unoline.status.provider.unique_path() }
-- @see unoline.status.utils.stylize
function unoline.status.provider.unique_path(opts)
	opts = unoline.default_tbl(opts, {
		buf_name = function(bufnr)
			return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")
		end,
		bufnr = 0,
		max_length = 16,
	})
	return function(self)
		opts.bufnr = self and self.bufnr or opts.bufnr
		local name = opts.buf_name(opts.bufnr)
		local unique_path = ""
		-- check for same buffer names under different dirs
		for _, value in ipairs(unoline.status.utils.get_valid_buffers()) do
			if name == opts.buf_name(value) and value ~= opts.bufnr then
				local other = {}
				for match in (vim.api.nvim_buf_get_name(value) .. "/"):gmatch("(.-)" .. "/") do
					table.insert(other, match)
				end

				local current = {}
				for match in (vim.api.nvim_buf_get_name(opts.bufnr) .. "/"):gmatch("(.-)" .. "/") do
					table.insert(current, match)
				end

				unique_path = ""

				for i = #current - 1, 1, -1 do
					local value_current = current[i]
					local other_current = other[i]

					if value_current ~= other_current then
						unique_path = value_current .. "/"
						break
					end
				end
				break
			end
		end
		return unoline.status.utils.stylize(
			(
			opts.max_length > 0
					and #unique_path > opts.max_length
					and string.sub(unique_path, 1, opts.max_length - 2) .. unoline.get_icon("Ellipsis") .. "/"
			) or unique_path,
			opts
		)
	end
end

--- A provider function for showing if the current file is modifiable
-- @param opts options passed to the stylize function
-- @return the function for outputting the indicator if the file is modified
-- @usage local heirline_component = { provider = unoline.status.provider.file_modified() }
-- @see unoline.status.utils.stylize
function unoline.status.provider.file_modified(opts)
	opts = unoline.default_tbl(opts, { str = "", icon = { kind = "FileModified" }, show_empty = true })
	return function(self)
		return unoline.status.utils.stylize(
			unoline.status.condition.file_modified((self or {}).bufnr) and opts.str,
			opts
		)
	end
end

--- A provider function for showing if the current file is read-only
-- @param opts options passed to the stylize function
-- @return the function for outputting the indicator if the file is read-only
-- @usage local heirline_component = { provider = unoline.status.provider.file_read_only() }
-- @see unoline.status.utils.stylize
function unoline.status.provider.file_read_only(opts)
	opts = unoline.default_tbl(opts, { str = "", icon = { kind = "FileReadOnly" }, show_empty = true })
	return function(self)
		return unoline.status.utils.stylize(
			unoline.status.condition.file_read_only((self or {}).bufnr) and opts.str,
			opts
		)
	end
end

--- A provider function for showing the current filetype icon
-- @param opts options passed to the stylize function
-- @return the function for outputting the filetype icon
-- @usage local heirline_component = { provider = unoline.status.provider.file_icon() }
-- @see unoline.status.utils.stylize
function unoline.status.provider.file_icon(opts)
	if not devicons_avail then
		return ""
	end
	return function(self)
		local ft_icon, _ = devicons.get_icon(
			vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self and self.bufnr or 0), ":t"),
			nil,
			{ default = true }
		)
		return unoline.status.utils.stylize(ft_icon, opts)
	end
end

--- A provider function for showing the current git branch
-- @param opts options passed to the stylize function
-- @return the function for outputting the git branch
-- @usage local heirline_component = { provider = unoline.status.provider.git_branch() }
-- @see unoline.status.utils.stylize
function unoline.status.provider.git_branch(opts)
	return function(self)
		return unoline.status.utils.stylize(vim.b[self and self.bufnr or 0].gitsigns_head or "", opts)
	end
end

--- A provider function for showing the current git diff count of a specific type
-- @param opts options for type of git diff and options passed to the stylize function
-- @return the function for outputting the git diff
-- @usage local heirline_component = { provider = unoline.status.provider.git_diff({ type = "added" }) }
-- @see unoline.status.utils.stylize
function unoline.status.provider.git_diff(opts)
	if not opts or not opts.type then
		return
	end
	return function(self)
		local status = vim.b[self and self.bufnr or 0].gitsigns_status_dict
		return unoline.status.utils.stylize(
			status and status[opts.type] and status[opts.type] > 0 and tostring(status[opts.type]) or "",
			opts
		)
	end
end

--- A provider function for showing the current diagnostic count of a specific severity
-- @param opts options for severity of diagnostic and options passed to the stylize function
-- @return the function for outputting the diagnostic count
-- @usage local heirline_component = { provider = unoline.status.provider.diagnostics({ severity = "ERROR" }) }
-- @see unoline.status.utils.stylize
function unoline.status.provider.diagnostics(opts)
	if not opts or not opts.severity then
		return
	end
	return function(self)
		local bufnr = self and self.bufnr or 0
		local options = opts.severity and { severity = vim.diagnostic.severity[opts.severity] }
		local count = #vim.diagnostic.get(bufnr, options)
		return unoline.status.utils.stylize(count ~= 0 and tostring(count) or "", opts)
	end
end

--- A provider function for showing the current diagnostic count of a specific severity
-- @param opts options for severity of diagnostic and options passed to the stylize function
-- @return the function for outputting the diagnostic count
-- @usage local heirline_component = { provider = unoline.status.provider.diagnostics({ severity = "ERROR" }) }
-- @see unoline.status.utils.stylize
function unoline.status.provider.neotest_status(opts)
	if not opts or not opts.status then
		return
	end
	return function(self)
		local fname = vim.api.nvim_buf_get_name(0)
		local options = { query = fname, total = true }
		if opts.status then
			options.status = opts.status
		end
		local count = require("neotest").state.get_status(options)
		local default = opts.show_empty and "0" or ""
		return unoline.status.utils.stylize(count ~= 0 and tostring(count) or default, opts)
	end
end

--- A provider function for showing the current diagnostic count of a specific severity
-- @param opts options for severity of diagnostic and options passed to the stylize function
-- @return the function for outputting the diagnostic count
-- @usage local heirline_component = { provider = unoline.status.provider.diagnostics({ severity = "ERROR" }) }
-- @see unoline.status.utils.stylize
function unoline.status.provider.neotest_running(opts)
	if not opts then
		return
	end

	local function get_index(len)
		return math.floor(vim.loop.hrtime() / 12e7) % len + 1
	end

	local icons = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
	return function(self)
		local f = vim.tbl_values(require("neotest").state.running())
		local testing = string.match(f[get_index(#f)].path, "[^/]*/[^/]*$")
		local str = string.format("Testing %s %s", testing, icons[get_index(#icons)])
		return unoline.status.utils.stylize(str, opts)
	end
end

--- A provider function for showing the current progress of loading language servers
-- @param opts options passed to the stylize function
-- @return the function for outputting the LSP progress
-- @usage local heirline_component = { provider = unoline.status.provider.lsp_progress() }
-- @see unoline.status.utils.stylize
function unoline.status.provider.lsp_progress(opts)
	return function()
		local Lsp = vim.lsp.util.get_progress_messages()[1]
		return unoline.status.utils.stylize(
			Lsp
			and string.format(
				" %%<%s %s %s (%s%%%%) ",
				unoline.get_icon("LSP" .. ((Lsp.percentage or 0) >= 70 and { "Loaded", "Loaded", "Loaded" } or {
					"Loading1",
					"Loading2",
					"Loading3",
				})[math.floor(vim.loop.hrtime() / 12e7) % 3 + 1]),
				Lsp.title or "",
				Lsp.message or "",
				Lsp.percentage or 0
			)
			or "",
			opts
		)
	end
end

--- A provider function for showing the connected LSP client names
-- @param opts options for explanding null_ls clients, max width percentage, and options passed to the stylize function
-- @return the function for outputting the LSP client names
-- @usage local heirline_component = { provider = unoline.status.provider.lsp_client_names({ expand_null_ls = true, truncate = 0.25 }) }
-- @see unoline.status.utils.stylize
function unoline.status.provider.lsp_client_names(opts)
	opts = unoline.default_tbl(opts, { expand_null_ls = true, truncate = 0.25 })
	return function(self)
		local buf_client_names = {}
		for _, client in pairs(vim.lsp.get_active_clients({ bufnr = self and self.bufnr or 0 })) do
			if client.name == "null-ls" and opts.expand_null_ls then
				local null_ls_sources = {}
				for _, type in ipairs({ "FORMATTING", "DIAGNOSTICS" }) do
					for _, source in ipairs(unoline.null_ls_sources(vim.bo.filetype, type)) do
						null_ls_sources[source] = true
					end
				end
				vim.list_extend(buf_client_names, vim.tbl_keys(null_ls_sources))
			else
				table.insert(buf_client_names, client.name)
			end
		end
		local str = table.concat(buf_client_names, ", ")
		if type(opts.truncate) == "number" then
			local max_width = math.floor(unoline.status.utils.width() * opts.truncate)
			if #str > max_width then
				str = string.sub(str, 0, max_width) .. "…"
			end
		end
		return unoline.status.utils.stylize(str, opts)
	end
end

--- A provider function for showing if treesitter is connected
-- @param opts options passed to the stylize function
-- @return the function for outputting TS if treesitter is connected
-- @usage local heirline_component = { provider = unoline.status.provider.treesitter_status() }
-- @see unoline.status.utils.stylize
function unoline.status.provider.treesitter_status(opts)
	return function()
		local ts_avail, ts = pcall(require, "nvim-treesitter.parsers")
		return unoline.status.utils.stylize((ts_avail and ts.has_parser()) and "TS" or "", opts)
	end
end

--- A provider function for displaying a single string
-- @param opts options passed to the stylize function
-- @return the stylized statusline string
-- @usage local heirline_component = { provider = unoline.status.provider.str({ str = "Hello" }) }
-- @see unoline.status.utils.stylize
function unoline.status.provider.str(opts)
	opts = unoline.default_tbl(opts, { str = " " })
	return unoline.status.utils.stylize(opts.str, opts)
end

--- A condition function if the window is currently active
-- @return boolean of wether or not the window is currently actie
-- @usage local heirline_component = { provider = "Example Provider", condition = unoline.status.condition.is_active }
function unoline.status.condition.is_active()
	return vim.api.nvim_get_current_win() == tonumber(vim.g.actual_curwin)
end

--- A condition function if the buffer filetype,buftype,bufname match a pattern
-- @return boolean of wether or not LSP is attached
-- @usage local heirline_component = { provider = "Example Provider", condition = function() return unoline.status.condition.buffer_matches { buftype = { "terminal" } } end }
function unoline.status.condition.buffer_matches(patterns)
	for kind, pattern_list in pairs(patterns) do
		if unoline.status.env.buf_matchers[kind](pattern_list) then
			return true
		end
	end
	return false
end

--- A condition function if a macro is being recorded
-- @return boolean of wether or not a macro is currently being recorded
-- @usage local heirline_component = { provider = "Example Provider", condition = unoline.status.condition.is_macro_recording }
function unoline.status.condition.is_macro_recording()
	return vim.fn.reg_recording() ~= ""
end

--- A condition function if the current file is in a git repo
-- @return boolean of wether or not the current file is in a git repo
-- @usage local heirline_component = { provider = "Example Provider", condition = unoline.status.condition.is_git_repo }
function unoline.status.condition.is_git_repo()
	return vim.b.gitsigns_head or vim.b.gitsigns_status_dict
end

--- A condition function if there are any git changes
-- @return boolean of wether or not there are any git changes
-- @usage local heirline_component = { provider = "Example Provider", condition = unoline.status.condition.git_changed }
function unoline.status.condition.git_changed()
	local git_status = vim.b.gitsigns_status_dict
	return git_status and (git_status.added or 0) + (git_status.removed or 0) + (git_status.changed or 0) > 0
end

--- A condition function if the current buffer is modified
-- @return boolean of wether or not the current buffer is modified
-- @usage local heirline_component = { provider = "Example Provider", condition = unoline.status.condition.file_modified }
function unoline.status.condition.file_modified(bufnr)
	return vim.bo[bufnr or 0].modified
end

--- A condition function if the current buffer is read only
-- @return boolean of wether or not the current buffer is read only or not modifiable
-- @usage local heirline_component = { provider = "Example Provider", condition = unoline.status.condition.file_read_only }
function unoline.status.condition.file_read_only(bufnr)
	local buffer = vim.bo[bufnr or 0]
	return not buffer.modifiable or buffer.readonly
end

--- A condition function if the current file has any diagnostics
-- @return boolean of wether or not the current file has any diagnostics
-- @usage local heirline_component = { provider = "Example Provider", condition = unoline.status.condition.has_diagnostics }
function unoline.status.condition.has_diagnostics()
	return vim.g.status_diagnostics_enabled and #vim.diagnostic.get(0) > 0
end

--- A condition function if the current file has any neotest results
-- @return boolean of wether or not the current file has any test results
-- @usage local heirline_component = { provider = "Example Provider", condition = unoline.status.condition.has_diagnostics }
function unoline.status.condition.has_test_results()
	local fname = vim.api.nvim_buf_get_name(0)
	local status = require("neotest").state.get_status({ query = fname, total = true })
	return vim.g.neotest_result_enabled and status
end

--- A condition function if neotest is currently running
-- @return boolean of wether or not the current file has any diagnostics
-- @usage local heirline_component = { provider = "Example Provider", condition = unoline.status.condition.has_diagnostics }
function unoline.status.condition.is_neotest_running()
	local fname = vim.api.nvim_buf_get_name(0)
	local status = require("neotest").state.running({ adapter_id = fname, fuzzy = true })
	return vim.g.neotest_result_enabled and status ~= nil
end

--- A condition function if there is a defined filetype
-- @return boolean of wether or not there is a filetype
-- @usage local heirline_component = { provider = "Example Provider", condition = unoline.status.condition.has_filetype }
function unoline.status.condition.has_filetype()
	return vim.fn.empty(vim.fn.expand("%:t")) ~= 1 and vim.bo.filetype and vim.bo.filetype ~= ""
end

--- A condition function if Aerial is available
-- @return boolean of wether or not aerial plugin is installed
-- @usage local heirline_component = { provider = "Example Provider", condition = unoline.status.condition.aerial_available }
function unoline.status.condition.aerial_available()
	return unoline.is_available("aerial.nvim")
end

--- A condition function if LSP is attached
-- @return boolean of wether or not LSP is attached
-- @usage local heirline_component = { provider = "Example Provider", condition = unoline.status.condition.lsp_attached }
function unoline.status.condition.lsp_attached()
	return next(vim.lsp.buf_get_clients()) ~= nil
end

--- A condition function if treesitter is in use
-- @return boolean of wether or not treesitter is active
-- @usage local heirline_component = { provider = "Example Provider", condition = unoline.status.condition.treesitter_available }
function unoline.status.condition.treesitter_available()
	local ts_avail, ts = pcall(require, "nvim-treesitter.parsers")
	return ts_avail and ts.has_parser()
end

--- A utility function to stylize a string with an icon from lspkind, separators, and left/right padding
-- @param str the string to stylize
-- @param opts options of `{ padding = { left = 0, right = 0 }, separator = { left = "|", right = "|" }, show_empty = false, icon = { kind = "NONE", padding = { left = 0, right = 0 } } }`
-- @return the stylized string
-- @usage local string = unoline.status.utils.stylize("Hello", { padding = { left = 1, right = 1 }, icon = { kind = "String" } })
function unoline.status.utils.stylize(str, opts)
	opts = unoline.default_tbl(opts, {
		padding = { left = 0, right = 0 },
		separator = { left = "", right = "" },
		show_empty = false,
		icon = { kind = "NONE", padding = { left = 0, right = 0 } },
	})
	local icon = unoline.pad_string(unoline.get_icon(opts.icon.kind), opts.icon.padding)
	return str
			and (str ~= "" or opts.show_empty)
			and opts.separator.left .. unoline.pad_string(icon .. str, opts.padding) .. opts.separator.right
			or ""
end

--- A Heirline component for filling in the empty space of the bar
-- @return The heirline component table
-- @usage local heirline_component = unoline.status.component.fill()
function unoline.status.component.fill()
	return { provider = unoline.status.provider.fill() }
end

--- A function to build a set of children components for an entire file information section
-- @param opts options for configuring file_icon, filename, filetype, file_modified, file_read_only, and the overall padding
-- @return The Heirline component table
-- @usage local heirline_component = unoline.status.component.file_info()
function unoline.status.component.file_info(opts)
	opts = unoline.default_tbl(opts, {
		file_icon = { highlight = true, padding = { left = 1, right = 1 } },
		filename = {},
		file_modified = { padding = { left = 1 } },
		file_read_only = { padding = { left = 1 } },
		surround = {
			separator = "left",
			color = "file_info_bg",
			condition = function()
				if not unoline.status.condition.has_filetype() then
					return false
				end

				local ignore = { "nofile", "NvimTree", "terminal", "Outline", "neotest-summary" }
				if unoline.status.env.buf_matchers.buftype(ignore) then
					return false
				end
				if unoline.status.env.buf_matchers.filetype(ignore) then
					return false
				end
				return true
			end,
		},
		hl = { fg = "file_info_fg", bold = true },
	})
	for i, key in ipairs({
		"file_icon",
		"unique_path",
		"filename",
		"filetype",
		"file_modified",
		"file_read_only",
		"close_button",
	}) do
		opts[i] = opts[key]
				and {
					provider = key,
					opts = opts[key],
					hl = opts[key].highlight and unoline.status.hl.filetype_color or opts[key].hl,
					on_click = opts[key].on_click,
				}
				or false
	end
	return unoline.status.component.builder(opts)
end

--- A function to build a set of children components for an entire navigation section
-- @param opts options for configuring ruler, percentage, scrollbar, and the overall padding
-- @return The Heirline component table
-- @usage local heirline_component = unoline.status.component.nav()
function unoline.status.component.nav(opts)
	opts = unoline.default_tbl(opts, {
		ruler = {},
		percentage = { padding = { left = 1 } },
		scrollbar = { padding = { left = 1 }, hl = { fg = "scrollbar" } },
		surround = { separator = "right", color = "nav_bg" },
		hl = { fg = "nav_fg" },
		update = { "CursorMoved", "BufEnter" },
	})
	for i, key in ipairs({ "ruler", "percentage", "scrollbar" }) do
		opts[i] = opts[key] and { provider = key, opts = opts[key], hl = opts[key].hl } or false
	end
	return unoline.status.component.builder(opts)
end

--- A function to build a set of children components for a macro recording section
-- @param opts options for configuring macro recording and the overall padding
-- @return The Heirline component table
-- @usage local heirline_component = unoline.status.component.macro_recording()
function unoline.status.component.macro_recording(opts)
	opts = unoline.default_tbl(opts, {
		macro_recording = { icon = { kind = "MacroRecording", padding = { right = 1 } } },
		surround = {
			separator = "center",
			color = "macro_recording_bg",
			condition = unoline.status.condition.is_macro_recording,
		},
		hl = { fg = "macro_recording_fg", bold = true },
		update = { "RecordingEnter", "RecordingLeave" },
	})
	opts[1] = opts.macro_recording and { provider = "macro_recording", opts = opts.macro_recording } or false
	return unoline.status.component.builder(opts)
end

--- A function to build a set of children components for a mode section
-- @param opts options for configuring mode_text, paste, spell, and the overall padding
-- @return The Heirline component table
-- @usage local heirline_component = unoline.status.component.mode { mode_text = true }
function unoline.status.component.mode(opts)
	opts = unoline.default_tbl(opts, {
		mode_text = false,
		paste = false,
		spell = false,
		surround = { separator = "left", color = unoline.status.hl.mode_bg },
		hl = { fg = "bg" },
		update = "ModeChanged",
	})
	for i, key in ipairs({ "mode_text", "paste", "spell" }) do
		if key == "mode_text" and not opts[key] then
			opts[i] = { provider = "str", opts = { str = " " } }
		else
			opts[i] = opts[key] and { provider = key, opts = opts[key], hl = opts[key].hl } or false
		end
	end
	return unoline.status.component.builder(opts)
end

--- A function to build a set of children components for an LSP breadcrumbs section
-- @param opts options for configuring breadcrumbs and the overall padding
-- @return The Heirline component table
-- @usage local heirline_component = unoline.status.component.breadcumbs()
function unoline.status.component.breadcrumbs(opts)
	opts = unoline.default_tbl(
		opts,
		{ padding = { left = 1 }, condition = unoline.status.condition.aerial_available, update = "CursorMoved" }
	)
	opts.init = unoline.status.init.breadcrumbs(opts)
	return opts
end

--- A function to build a set of children components for a git branch section
-- @param opts options for configuring git branch and the overall padding
-- @return The Heirline component table
-- @usage local heirline_component = unoline.status.component.git_branch()
function unoline.status.component.git_branch(opts)
	opts = unoline.default_tbl(opts, {
		git_branch = { icon = { kind = "GitBranch", padding = { right = 1 } } },
		surround = { separator = "left", color = "git_branch_bg", condition = unoline.status.condition.is_git_repo },
		hl = { fg = "git_branch_fg", bold = true },
		on_click = {
			name = "heirline_branch",
			callback = function()
				if unoline.is_available("telescope.nvim") then
					vim.defer_fn(function()
						require("telescope.builtin").git_branches()
					end, 100)
				end
			end,
		},
		update = { "User", pattern = "GitSignsUpdate" },
		init = unoline.status.init.update_events({ "BufEnter" }),
	})
	opts[1] = opts.git_branch and { provider = "git_branch", opts = opts.git_branch } or false
	return unoline.status.component.builder(opts)
end

--- A function to build a set of children components for a git difference section
-- @param opts options for configuring git changes and the overall padding
-- @return The Heirline component table
-- @usage local heirline_component = unoline.status.component.git_diff()
function unoline.status.component.git_diff(opts)
	opts = unoline.default_tbl(opts, {
		added = { icon = { kind = "GitAdd", padding = { left = 1, right = 1 } } },
		changed = { icon = { kind = "GitChange", padding = { left = 1, right = 1 } } },
		removed = { icon = { kind = "GitDelete", padding = { left = 1, right = 1 } } },
		hl = { fg = "git_diff_fg", bold = true },
		on_click = {
			name = "heirline_git",
			callback = function()
				if unoline.is_available("telescope.nvim") then
					vim.defer_fn(function()
						require("telescope.builtin").git_status()
					end, 100)
				end
			end,
		},
		surround = { separator = "left", color = "git_diff_bg", condition = unoline.status.condition.git_changed },
		update = { "User", pattern = "GitSignsUpdate" },
		init = unoline.status.init.update_events({ "BufEnter" }),
	})
	for i, kind in ipairs({ "added", "changed", "removed" }) do
		if type(opts[kind]) == "table" then
			opts[kind].type = kind
		end
		opts[i] = opts[kind] and { provider = "git_diff", opts = opts[kind], hl = { fg = "git_" .. kind } } or false
	end
	return unoline.status.component.builder(opts)
end

--- A function to build a set of children components for a diagnostics section
-- @param opts options for configuring diagnostic providers and the overall padding
-- @return The Heirline component table
-- @usage local heirline_component = unoline.status.component.diagnostics()
function unoline.status.component.diagnostics(opts)
	opts = unoline.default_tbl(opts, {
		ERROR = { icon = { kind = "DiagnosticError", padding = { left = 1, right = 1 } } },
		WARN = { icon = { kind = "DiagnosticWarn", padding = { left = 1, right = 1 } } },
		INFO = { icon = { kind = "DiagnosticInfo", padding = { left = 1, right = 1 } } },
		HINT = { icon = { kind = "DiagnosticHint", padding = { left = 1, right = 1 } } },
		surround = {
			separator = "left",
			color = "diagnostics_bg",
			condition = unoline.status.condition.has_diagnostics,
		},
		hl = { fg = "diagnostics_fg" },
		on_click = {
			name = "heirline_diagnostic",
			callback = function()
				if unoline.is_available("telescope.nvim") then
					vim.defer_fn(function()
						require("telescope.builtin").diagnostics()
					end, 100)
				end
			end,
		},
		update = { "DiagnosticChanged", "BufEnter" },
	})

	for i, kind in ipairs({ "ERROR", "WARN", "INFO", "HINT" }) do
		if type(opts[kind]) == "table" then
			opts[kind].severity = kind
		end
		opts[i] = opts[kind] and { provider = "diagnostics", opts = opts[kind], hl = { fg = "diag_" .. kind } } or false
	end

	return unoline.status.component.builder(opts)
end

--- A function to build a set of children components for a diagnostics section
-- @param opts options for configuring diagnostic providers and the overall padding
-- @return The Heirline component table
-- @usage local heirline_component = unoline.status.component.diagnostics()
function unoline.status.component.neotest_status(opts)
	opts = unoline.default_tbl(opts, {
		passed = { icon = { kind = "TestPassed", padding = { left = 1, right = 1 } }, show_empty = true },
		failed = { icon = { kind = "TestFailed", padding = { left = 1, right = 1 } }, show_empty = true },
		skipped = { icon = { kind = "TestSkiped", padding = { left = 1, right = 1 } } },
		unknown = { icon = { kind = "TestUnknown", padding = { left = 1, right = 1 } } },
		surround = {
			separator = "left",
			color = "neotest_status_bg",
			condition = unoline.status.condition.has_test_results,
		},
		hl = { fg = "neotest_status_fg", bold = true },
		on_click = {
			name = "heirline_neotest_status",
			callback = function()
				if unoline.is_available("neotest") then
					vim.defer_fn(function()
						require("neotest").summary.open()
					end, 100)
				end
			end,
		},
		update = { "User", pattern = "NeoTestStatus" },
		init = unoline.status.init.update_events({ "BufEnter" }),
	})

	for i, status in ipairs({ "passed", "failed", "skipped", "unknown" }) do
		if type(opts[status]) == "table" then
			opts[status].status = status
		end
		opts[i] = opts[status]
				and { provider = "neotest_status", opts = opts[status], hl = { fg = "neotest_" .. status } }
				or false
	end

	return unoline.status.component.builder(opts)
end

--- A function to build a set of children components for a Treesitter section
-- @param opts options for configuring diagnostic providers and the overall padding
-- @return The Heirline component table
-- @usage local heirline_component = unoline.status.component.treesitter()
function unoline.status.component.neotest_running(opts)
	opts = unoline.default_tbl(opts, {
		neotest_running = { icon = { kind = "TestRunning", padding = { left = 1, right = 1 } } },
		surround = {
			separator = "right",
			color = "neotest_bg",
			condition = unoline.status.condition.is_neotest_running,
		},
		hl = { fg = "neotest_fg", bold = true },
		-- update = { "User", pattern = "NeoTestStarted" },
		-- init = unoline.status.init.update_events({ "BufEnter" }),
	})
	opts[1] = opts.neotest_running and { provider = "neotest_running", opts = opts.neotest_running } or false
	return unoline.status.component.builder(opts)
end

--- A function to build a set of children components for a Treesitter section
-- @param opts options for configuring diagnostic providers and the overall padding
-- @return The Heirline component table
-- @usage local heirline_component = unoline.status.component.treesitter()
function unoline.status.component.treesitter(opts)
	opts = unoline.default_tbl(opts, {
		str = { str = "TS", icon = { kind = "ActiveTS" } },
		surround = {
			separator = "right",
			color = "treesitter_bg",
			condition = unoline.status.condition.treesitter_available,
		},
		hl = { fg = "treesitter_fg" },
		update = { "OptionSet", pattern = "syntax" },
		init = unoline.status.init.update_events({ "BufEnter" }),
	})
	opts[1] = opts.str and { provider = "str", opts = opts.str } or false
	return unoline.status.component.builder(opts)
end

--- A function to build a set of children components for an LSP section
-- @param opts options for configuring lsp progress and client_name providers and the overall padding
-- @return The Heirline component table
-- @usage local heirline_component = unoline.status.component.lsp()
function unoline.status.component.lsp(opts)
	opts = unoline.default_tbl(opts, {
		lsp_progress = { str = "", padding = { right = 1 } },
		lsp_client_names = { str = "LSP", icon = { kind = "ActiveLSP", padding = { right = 2 } } },
		hl = { fg = "lsp_fg", italic = true },
		surround = { separator = "right", color = "lsp_bg", condition = unoline.status.condition.lsp_attached },
		on_click = {
			name = "heirline_lsp",
			callback = function()
				vim.defer_fn(function()
					vim.cmd("LspInfo")
				end, 100)
			end,
		},
	})
	opts[1] = {}
	for i, provider in ipairs({ "lsp_progress", "lsp_client_names" }) do
		if type(opts[provider]) == "table" then
			local new_provider = opts[provider].str
					and unoline.status.utils.make_flexible(
						i,
						{ provider = unoline.status.provider[provider](opts[provider]) },
						{ provider = unoline.status.provider.str(opts[provider]) }
					)
					or { provider = provider, opts = opts[provider] }
			if provider == "lsp_client_names" then
				new_provider.update = { "LspAttach", "LspDetach", "BufEnter" }
			end
			table.insert(opts[1], new_provider)
		end
	end
	return unoline.status.component.builder(opts)
end

--- A general function to build a section of unoline status providers with highlights, conditions, and section surrounding
-- @param opts a list of components to build into a section
-- @return The Heirline component table
-- @usage local heirline_component = unoline.status.components.builder({ { provider = "file_icon", opts = { padding = { right = 1 } } }, { provider = "filename" } })
function unoline.status.component.builder(opts)
	opts = unoline.default_tbl(opts, { padding = { left = 0, right = 0 } })
	local children = {}
	if opts.padding.left > 0 then -- add left padding
		table.insert(children, { provider = unoline.pad_string(" ", { left = opts.padding.left - 1 }) })
	end
	for key, entry in pairs(opts) do
		if type(key) == "number"
				and type(entry) == "table"
				and unoline.status.provider[entry.provider]
				and (entry.opts == nil or type(entry.opts) == "table")
		then
			entry.provider = unoline.status.provider[entry.provider](entry.opts)
		end
		children[key] = entry
	end
	if opts.padding.right > 0 then -- add right padding
		table.insert(children, { provider = unoline.pad_string(" ", { right = opts.padding.right - 1 }) })
	end
	return opts.surround
			and unoline.status.utils.surround(
				opts.surround.separator,
				opts.surround.color,
				children,
				opts.surround.condition
			)
			or children
end

--- A utility function to get the width of the bar
-- @param is_winbar boolean true if you want the width of the winbar, false if you want the statusline width
-- @return the width of the specified bar
function unoline.status.utils.width(is_winbar)
	return vim.o.laststatus == 3 and not is_winbar and vim.o.columns or vim.api.nvim_win_get_width(0)
end

local function insert(destination, ...)
	local new = unoline.default_tbl({}, destination)
	for _, child in ipairs({ ... }) do
		table.insert(new, unoline.default_tbl({}, child))
	end
	return new
end

--- Create a flexible statusline component
-- @param priority the priority of the element
-- @return the flexible component that switches between components to fit the width
function unoline.status.utils.make_flexible(priority, ...)
	local new = insert({}, ...)
	new.static = { _priority = priority }
	new.init = function(self)
		if not vim.tbl_contains(self._flexible_components, self) then
			table.insert(self._flexible_components, self)
		end
		self:set_win_attr("_win_child_index", nil, 1)
		self.pick_child = { self:get_win_attr("_win_child_index") }
	end
	new.restrict = { _win_child_index = true }
	return new
end

--- Surround component with separator and color adjustment
-- @param separator the separator index to use in `unoline.status.env.separators`
-- @param color the color to use as the separator foreground/component background
-- @param component the component to surround
-- @param condition the condition for displaying the surrounded component
-- @return the new surrounded component
function unoline.status.utils.surround(separator, color, component, condition)
	local function surround_color(self)
		local colors = type(color) == "function" and color(self) or color
		return type(colors) == "string" and { main = colors } or colors
	end

	separator = type(separator) == "string" and unoline.status.env.separators[separator] or separator
	local surrounded = { condition = condition }
	if separator[1] ~= "" then
		table.insert(surrounded, {
			provider = separator[1],
			hl = function(self)
				local s_color = surround_color(self)
				if s_color then
					return { fg = s_color.main, bg = s_color.left }
				end
			end,
		})
	end
	table.insert(surrounded, {
		hl = function(self)
			local s_color = surround_color(self)
			if s_color then
				return { bg = s_color.main }
			end
		end,
		unoline.default_tbl({}, component),
	})
	if separator[2] ~= "" then
		table.insert(surrounded, {
			provider = separator[2],
			hl = function(self)
				local s_color = surround_color(self)
				if s_color then
					return { fg = s_color.main, bg = s_color.right }
				end
			end,
		})
	end
	return surrounded
end

--- Check if a buffer is valid
-- @param bufnr the buffer to check
-- @return true if the buffer is valid or false
function unoline.status.utils.is_valid_buffer(bufnr)
	if not bufnr or bufnr < 1 then
		return false
	end
	return vim.bo[bufnr].buflisted and vim.api.nvim_buf_is_valid(bufnr)
end

--- Get all valid buffers
-- @return array-like table of valid buffer numbers
function unoline.status.utils.get_valid_buffers()
	return vim.tbl_filter(unoline.status.utils.is_valid_buffer, vim.api.nvim_list_bufs())
end

--- Encode a position to a single value that can be decoded later
-- @param line line number of position
-- @param col column number of position
-- @param winnr a window number
-- @return the encoded position
function unoline.status.utils.encode_pos(line, col, winnr)
	return bit.bor(bit.lshift(line, 16), bit.lshift(col, 6), winnr)
end

--- Decode a previously encoded position to it's sub parts
-- @param c the encoded position
-- @return line number, column number, window id
function unoline.status.utils.decode_pos(c)
	return bit.rshift(c, 16), bit.band(bit.rshift(c, 6), 1023), bit.band(c, 63)
end

return unoline.status
