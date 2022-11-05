local heirline = require("heirline")
-- local C = require("default_theme.colors")

-- convert Lush theme hsl color format to string
local function getColor(color)
	if type(color) == "string" then
		return color
	end
	if color ~= nil then
		return color.hex
	end
	return ""
end

local function setup_colors()
	-- Load colors
	package.loaded["themes.pywal"] = nil
	local theme = require("themes.pywal")

	local colors = {
		fg = getColor(theme.ModesReplace.fg),
		bg = getColor(theme.StatusLine.bg),
		section_fg = getColor(theme.StatusLine.fg),
		section_bg = getColor(theme.StatusLine.bg),
		lsp_fg = getColor(theme.TSVariable.fg),
		file_info_fg = getColor(theme.TSField.fg),
		git_branch_fg = getColor(theme.GitBranch.fg),
		treesitter_fg = getColor(theme.ModesNormal.bg),
		scrollbar = getColor(theme.Orange.fg),
		git_added = getColor(theme.NotifyINFOIcon.fg),
		git_changed = getColor(theme.NotifyTRACETitle.fg),
		git_removed = "Red",
		diag_ERROR = "Red",
		diag_WARN = "Orange",
		diag_INFO = getColor(theme.LspDiagnosticsFloatingInformation.fg),
		diag_HINT = getColor(theme.Yellow.fg),
		normal = getColor(theme.ModesNormal.bg),
		insert = getColor(theme.ModesInsert.bg),
		visual = getColor(theme.ModesVisual.bg),
		replace = getColor(theme.ModesReplace.bg),
		command = getColor(theme.ModesCommand.bg),
		inactive = getColor(theme.NotifyDEBUGTitle.fg),
		winbar_fg = getColor(theme.WinBar.fg),
		winbar_bg = getColor(theme.WinBar.bg),
		winbarnc_fg = getColor(theme.WinBarNC.fg),
		winbarnc_bg = getColor(theme.WinBarNC.bg),
		neotest_fg = getColor(theme.NeotestPassed.fg),
		neotest_passed = getColor(theme.NeotestPassed.fg),
		neotest_failed = getColor(theme.NeotestFailed.fg),
		neotest_skipped = getColor(theme.NeotestSkipped.fg),
		neotest_unknown = getColor(theme.NeotestUnknown.fg),
		-- nav_bg = getColor(theme.WinBar.fg),
	}

	for _, section in ipairs({
		"git_branch",
		"git_diff",
		"file_info",
		"diagnostics",
		"lsp",
		"macro_recording",
		"treesitter",
		"nav",
		"neotest_status",
		"neotest",
	}) do
		if not colors[section .. "_bg"] then
			colors[section .. "_bg"] = colors["section_bg"]
		end
		if not colors[section .. "_fg"] then
			colors[section .. "_fg"] = colors["section_fg"]
		end
	end
	return colors
end

local unoline = require("uno.heirline.astro.init")

vim.g.icons_enabled = true -- heirline icons instead of text icons
vim.g.status_diagnostics_enabled = true
vim.g.diagnostics_enabled = true

vim.fn.matchadd("HighlightURL", unoline.url_matcher, 15)

local heirline_opts = {
	-- StatusLine
	status_line = {
		hl = { fg = "fg", bg = "bg" },
		unoline.status.component.mode(),
		unoline.status.component.git_branch(),
		unoline.status.component.git_diff(),
		unoline.status.component.file_info(
			-- unoline.is_available("bufferline.nvim") and { filetype = {}, filename = false, file_modified = false }
			-- 	or nil
		),
		unoline.status.component.diagnostics(),
		unoline.status.component.neotest_status(),
		unoline.status.component.fill(),
		unoline.status.component.neotest_running(),
		unoline.status.component.macro_recording(),
		unoline.status.component.fill(),
		unoline.status.component.lsp(),
		unoline.status.component.treesitter(),
		unoline.status.component.nav(),
		unoline.status.component.mode({ surround = { separator = "right" } }),
	},
	-- WindowBar
	win_bar = {
		fallthrough = false,
		{
			condition = function()
				return unoline.status.condition.buffer_matches({
					buftype = { "terminal", "prompt", "nofile", "help", "quickfix" },
					filetype = { "NvimTree", "neo-tree", "dashboard", "Outline", "aerial" },
				})
			end,
			init = function()
				vim.opt_local.winbar = nil
			end,
		},
		-- Show breadcrumbs on active window bar
		{
			condition = unoline.status.condition.is_active,
			unoline.status.component.breadcrumbs({ hl = { fg = "winbar_fg", bg = "winbar_bg" } }),
		},
		-- Winbar for inactive windows
		unoline.status.component.file_info({
			file_icon = { highlight = false },
			hl = { fg = "winbarnc_fg", bg = "winbarnc_bg" },
			surround = false,
		}),
	},
}

local setupHeirline = function()
	heirline.load_colors(setup_colors())
	heirline.setup(heirline_opts.status_line, heirline_opts.win_bar)
end

setupHeirline()

vim.api.nvim_create_augroup("Heirline", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
	group = "Heirline",
	desc = "Refresh heirline colors",
	callback = function()
		-- Probably excessive but doesn't hurt
		vim.schedule(function()
			heirline.reset_highlights()
			setupHeirline()
		end)
	end,
})
