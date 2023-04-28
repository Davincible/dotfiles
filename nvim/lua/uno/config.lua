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
vim.go.mousemodel = "extend"

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

vim.opt.wildignore = {
    "*.pyc",
    "*_build/*",
    "**/coverage/*",
    "**/node_modules/*",
    "**/android/*",
    "**/ios/*",
    "**/.git/*"
}

local _term = vim.api.nvim_create_augroup("Terminal", {clear = true})
vim.api.nvim_create_autocmd(
    "TermOpen",
    {
        pattern = "*",
        callback = function()
            vim.wo.relativenumber = false
            vim.wo.number = false
            -- vim.cmd("startinsert")
        end,
        group = _term
    }
)

local _ft = vim.api.nvim_create_augroup("FileTypeSettings", {clear = true})
-- Lua
vim.api.nvim_create_autocmd(
    "FileType",
    {
        pattern = "lua",
        callback = function()
            vim.bo.tabstop = 2
            vim.bo.shiftwidth = 2
        end,
        group = _ft
    }
)
vim.api.nvim_create_autocmd(
    "FileType",
    {
        pattern = "sh",
        callback = function()
            vim.bo.tabstop = 2
            vim.bo.shiftwidth = 2
        end,
        group = _ft
    }
)
vim.api.nvim_create_autocmd(
    "FileType",
    {
        pattern = "javascript",
        callback = function()
            vim.bo.expandtab = true
            vim.bo.tabstop = 2
            vim.bo.shiftwidth = 2
        end,
        group = _ft
    }
)
vim.api.nvim_create_autocmd(
    "FileType",
    {
        pattern = "Outline",
        callback = function()
            vim.wo.signcolumn = "no"
        end,
        group = _ft
    }
)

-- Auto lushify theme file when editing
vim.api.nvim_create_autocmd(
    "BufEnter",
    {
        pattern = "pywal.lua",
        callback = function()
            -- Disable diagnostics for current window
            vim.diagnostic.disable(0)
            vim.wo.cursorline = false

            local opts = {natural_timeout = 200, error_timeout = 500}
            -- Lushify to update colors in real time
            require("lush").ify(opts)

            -- Re-enable lushify on colorscheme change
            vim.api.nvim_create_augroup("Lushify", {clear = true})
            vim.api.nvim_create_autocmd(
                "ColorScheme",
                {
                    group = "Lushify",
                    desc = "Enable Lushify",
                    callback = function()
                        vim.schedule(
                            function()
                                vim.wo.cursorline = false
                                require("lush").ify(opts)
                            end
                        )
                    end
                }
            )
        end,
        group = _ft
    }
)

require("stickybuf").setup()
