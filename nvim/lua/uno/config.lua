-- Global Options
-- vim.go.guicursor    = "block"
vim.go.termguicolors = true
vim.go.hlsearch = false
vim.go.hidden = true
vim.go.errorbells = false
vim.go.ignorecase = true
vim.go.smartcase = true
vim.go.scrolloff = 12
vim.go.sidescrolloff = 21
--  vim.go.completeopt  = "menuone,noinsert,preview"
vim.go.completeopt = "menuone,noselect"
vim.go.cmdheight = 1
vim.go.mouse = "a"
vim.go.clipboard = "unnamedplus,unnamed"
vim.go.wildmenu = true
vim.go.wildmode = "longest,list,full"
vim.go.undodir = os.getenv("HOME") .. "/.nvim/undodir"
vim.go.backupdir = os.getenv("HOME") .. "/.nvim/backups"
vim.go.backup = true
vim.go.updatetime = 100
vim.go.fillchars = "eob: "
vim.go.laststatus = 3
vim.go.splitright = true
vim.go.splitbelow = false
vim.go.mousemodel = "extend"

-- Window Options
vim.wo.relativenumber = true
vim.wo.nu = true
vim.wo.wrap = false
vim.wo.colorcolumn = "80"
vim.wo.signcolumn = "yes"

-- Buffer Options
vim.bo.tabstop = 2
vim.bo.softtabstop = 2
vim.bo.shiftwidth = 2
vim.bo.expandtab = true
vim.bo.smartindent = true
vim.bo.autoindent = true
vim.bo.swapfile = false
vim.bo.undofile = true

-- Global Variables
vim.g.mapleader = " "
vim.g.python3_host_prog = "/usr/bin/python3"
vim.g.mkdp_browser = "/usr/bin/" .. vim.fn.expand("$BROWSER")

-- Statusline options
vim.g.icons_enabled = true -- heirline icons instead of text icons
vim.g.status_diagnostics_enabled = true
vim.g.diagnostics_enabled = true
vim.g.neotest_result_enabled = true

-- vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
-- vim.opt.foldcolumn = "0"
vim.o.foldcolumn = "1"

vim.opt.wildignore = {
	"*.pyc",
	"*_build/*",
	"**/coverage/*",
	"**/node_modules/*",
	"**/android/*",
	"**/ios/*",
	"**/.git/*",
}

local _term = vim.api.nvim_create_augroup("Terminal", { clear = true })
vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "*",
	callback = function()
		vim.wo.relativenumber = false
		vim.wo.number = false
		-- vim.cmd("startinsert")
	end,
	group = _term,
})

local _ft = vim.api.nvim_create_augroup("FileTypeSettings", { clear = true })
-- Lua
vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	callback = function()
		vim.bo.tabstop = 2
		vim.bo.shiftwidth = 2
	end,
	group = _ft,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "sh",
	callback = function()
		vim.bo.tabstop = 2
		vim.bo.shiftwidth = 2
	end,
	group = _ft,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
	callback = function()
		vim.bo.expandtab = true
		vim.bo.tabstop = 2
		vim.bo.shiftwidth = 2
	end,
	group = _ft,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "Outline",
	callback = function()
		vim.wo.signcolumn = "no"
	end,
	group = _ft,
})

-- Auto lushify theme file when editing
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "pywal.lua",
	callback = function()
		-- Disable diagnostics for current window
		vim.diagnostics.enable(false)
		vim.wo.cursorline = false

		local opts = { natural_timeout = 200, error_timeout = 500 }
		-- Lushify to update colors in real time
		require("lush").ify(opts)

		-- Re-enable lushify on colorscheme change
		vim.api.nvim_create_augroup("Lushify", { clear = true })
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = "Lushify",
			desc = "Enable Lushify",
			callback = function()
				vim.schedule(function()
					vim.wo.cursorline = false
					require("lush").ify(opts)
				end)
			end,
		})
	end,
	group = _ft,
})

-- require("stickybuf").setup()

-- TODO: move to right location
--Converts a hex color code string to a table of integer values
---@param hex_str string: Hex color code of the format `#rrggbb`
---@return table rgb: Table of {r, g, b} integers
local function hexToRgb(hex_str)
	local r, g, b = string.match(hex_str, "^#(%x%x)(%x%x)(%x%x)")
	assert(r, "Invalid hex string: " .. hex_str)
	return { tonumber(r, 16), tonumber(g, 16), tonumber(b, 16) }
end

---Blends two hex colors, given a blending amount
---@param fg string: A hex color code of the format `#rrggbb`
---@param bg string: A hex color code of the format `#rrggbb`
---@param alpha number: A blending factor, between `0` and `1`.
---@return string hex: A blended hex color code of the format `#rrggbb`
function blend(fg, bg, alpha)
	local bg_rgb = hexToRgb(bg)
	local fg_rgb = hexToRgb(fg)

	local blendChannel = function(i)
		local ret = (alpha * fg_rgb[i] + ((1 - alpha) * bg_rgb[i]))
		return math.floor(math.min(math.max(0, ret), 255) + 0.5)
	end

	return string.format("#%02X%02X%02X", blendChannel(1), blendChannel(2), blendChannel(3))
end

-- update foldcolumn ribbon colors
local create_autocmd = vim.api.nvim_create_autocmd
create_autocmd("ColorScheme", {
	callback = function()
		for i = 1, 8, 1 do
			vim.api.nvim_set_hl(0, "FoldCol" .. i, {
				bg = blend(
					string.format("#%06x", vim.api.nvim_get_hl(0, { name = "Normal" }).fg or 0),
					string.format("#%06x", vim.api.nvim_get_hl(0, { name = "Normal" }).bg or 0),
					0.125 * i
				),
				fg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg or 0,
			})
		end
	end,
})
