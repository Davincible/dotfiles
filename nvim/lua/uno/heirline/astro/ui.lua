unoline.ui = {}

local bool2str = function(bool)
	return bool and "on" or "off"
end

--- Toggle autopairs
function unoline.ui.toggle_autopairs()
	local ok, autopairs = pcall(require, "nvim-autopairs")
	if ok then
		if autopairs.state.disabled then
			autopairs.enable()
		else
			autopairs.disable()
		end
		vim.g.autopairs_enabled = autopairs.state.disabled
		unoline.notify(string.format("autopairs %s", bool2str(not autopairs.state.disabled)))
	else
		unoline.notify("autopairs not available")
	end
end

--- Toggle diagnostics
function unoline.ui.toggle_diagnostics()
	local status = "on"
	if vim.g.status_diagnostics_enabled then
		if vim.g.diagnostics_enabled then
			vim.g.diagnostics_enabled = false
			status = "virtual text off"
		else
			vim.g.status_diagnostics_enabled = false
			status = "fully off"
		end
	else
		vim.g.diagnostics_enabled = true
		vim.g.status_diagnostics_enabled = true
	end

	vim.diagnostic.config(unoline.lsp.diagnostics[bool2str(vim.g.diagnostics_enabled)])
	unoline.notify(string.format("diagnostics %s", status))
end

--- Toggle background="dark"|"light"
function unoline.ui.toggle_background()
	vim.go.background = vim.go.background == "light" and "dark" or "light"
	unoline.notify(string.format("background=%s", vim.go.background))
end

--- Toggle cmp entrirely
function unoline.ui.toggle_cmp()
	vim.g.cmp_enabled = not vim.g.cmp_enabled
	local ok, _ = pcall(require, "cmp")
	unoline.notify(ok and string.format("completion %s", bool2str(vim.g.cmp_enabled)) or "completion not available")
end

--- Toggle auto format
function unoline.ui.toggle_autoformat()
	vim.g.autoformat_enabled = not vim.g.autoformat_enabled
	unoline.notify(string.format("Autoformatting %s", bool2str(vim.g.autoformat_enabled)))
end

--- Toggle showtabline=2|0
function unoline.ui.toggle_tabline()
	vim.opt.showtabline = vim.opt.showtabline:get() == 0 and 2 or 0
	unoline.notify(string.format("tabline %s", bool2str(vim.opt.showtabline:get() == 2)))
end

--- Toggle laststatus=3|2|0
function unoline.ui.toggle_statusline()
	local laststatus = vim.opt.laststatus:get()
	local status
	if laststatus == 0 then
		vim.opt.laststatus = 2
		status = "local"
	elseif laststatus == 2 then
		vim.opt.laststatus = 3
		status = "global"
	elseif laststatus == 3 then
		vim.opt.laststatus = 0
		status = "off"
	end
	unoline.notify(string.format("statusline %s", status))
end

--- Toggle signcolumn="auto"|"no"
function unoline.ui.toggle_signcolumn()
	if vim.wo.signcolumn == "no" then
		vim.wo.signcolumn = "yes"
	elseif vim.wo.signcolumn == "yes" then
		vim.wo.signcolumn = "auto"
	else
		vim.wo.signcolumn = "no"
	end
	unoline.notify(string.format("signcolumn=%s", vim.wo.signcolumn))
end

--- Set the indent and tab related numbers
function unoline.ui.set_indent()
	local indent = tonumber(vim.fn.input("Set indent value (>0 expandtab, <=0 noexpandtab): "))
	if not indent or indent == 0 then
		return
	end
	vim.bo.expandtab = (indent > 0) -- local to buffer
	indent = math.abs(indent)
	vim.bo.tabstop = indent -- local to buffer
	vim.bo.softtabstop = indent -- local to buffer
	vim.bo.shiftwidth = indent -- local to buffer
	unoline.notify(string.format("indent=%d %s", indent, vim.bo.expandtab and "expandtab" or "noexpandtab"))
end

--- Change the number display modes
function unoline.ui.change_number()
	local number = vim.wo.number -- local to window
	local relativenumber = vim.wo.relativenumber -- local to window
	if not number and not relativenumber then
		vim.wo.number = true
	elseif number and not relativenumber then
		vim.wo.relativenumber = true
	elseif number and relativenumber then
		vim.wo.number = false
	else -- not number and relativenumber
		vim.wo.relativenumber = false
	end
	unoline.notify(
		string.format("number %s, relativenumber %s", bool2str(vim.wo.number), bool2str(vim.wo.relativenumber))
	)
end

--- Toggle spell
function unoline.ui.toggle_spell()
	vim.wo.spell = not vim.wo.spell -- local to window
	unoline.notify(string.format("spell %s", bool2str(vim.wo.spell)))
end

--- Toggle paste
function unoline.ui.toggle_paste()
	vim.opt.paste = not vim.opt.paste:get() -- local to window
	unoline.notify(string.format("paste %s", bool2str(vim.opt.paste:get())))
end

--- Toggle wrap
function unoline.ui.toggle_wrap()
	vim.wo.wrap = not vim.wo.wrap -- local to window
	unoline.notify(string.format("wrap %s", bool2str(vim.wo.wrap)))
end

--- Toggle syntax highlighting and treesitter
function unoline.ui.toggle_syntax()
	local ts_avail, parsers = pcall(require, "nvim-treesitter.parsers")
	if vim.g.syntax_on then -- global var for on//off
		if ts_avail and parsers.has_parser() then
			vim.cmd.TSBufDisable("highlight")
		end
		vim.cmd.syntax("off") -- set vim.g.syntax_on = false
	else
		if ts_avail and parsers.has_parser() then
			vim.cmd.TSBufEnable("highlight")
		end
		vim.cmd.syntax("on") -- set vim.g.syntax_on = true
	end
	unoline.notify(string.format("syntax %s", bool2str(vim.g.syntax_on)))
end

--- Toggle URL/URI syntax highlighting rules
function unoline.ui.toggle_url_match()
	vim.g.highlighturl_enabled = not vim.g.highlighturl_enabled
	unoline.set_url_match()
end
