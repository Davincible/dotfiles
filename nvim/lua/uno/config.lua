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
vim.go.cmdheight = 2
vim.go.mouse = "a"
vim.go.clipboard = "unnamedplus"
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

-- Window Options
vim.wo.relativenumber = true
vim.wo.nu = true
vim.wo.wrap = false
vim.wo.colorcolumn = "80"
vim.wo.signcolumn = "yes"
vim.wo.foldcolumn = "2"

-- Buffer Options
vim.bo.tabstop = 2
vim.bo.softtabstop = 2
vim.bo.shiftwidth = 2
vim.bo.expandtab = true
vim.bo.smartindent = true
vim.bo.autoindent = true
vim.bo.swapfile = true
vim.bo.undofile = true

-- Global Variables
vim.g.mapleader = " "
vim.g.python3_host_prog = "/usr/bin/python3"
vim.g.mkdp_browserfunc = "firefox"
-- vim.g.colorizer_auto_color = 1  -- might not be needed

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
		vim.cmd("startinsert")
	end,
	group = _term,
})
