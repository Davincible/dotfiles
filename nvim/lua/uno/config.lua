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

vim.cmd [[
" Ignore files
set wildignore+=*.pyc
set wildignore+=*_build/*
set wildignore+=**/coverage/*
set wildignore+=**/node_modules/*
set wildignore+=**/android/*
set wildignore+=**/ios/*
set wildignore+=**/.git/*
]]

-- au BufEnter,BufWinEnter,WinEnter,CmdwinEnter * if bufname('%') == "NvimTree" | set laststatus=0 | else | set laststatus=2 | endif
-- hide line numbers , statusline in specific buffers such as file tree and terminal
vim.api.nvim_exec(
    [[
   au BufEnter * highlight Normal guibg=0
   au BufEnter term://* setlocal nonumber
   au BufEnter zsh setlocal nonumber
   au BufEnter term://* set laststatus=0 
   au BufEnter zsh set laststatus=0 
   au BufEnter,BufWinEnter,WinEnter,CmdwinEnter NvimTree* set laststatus=0 
   au FileType qf set laststatus=0
]],
    false
)

-- Format HTML on save
vim.api.nvim_exec([[ autocmd BufWritePre *.html :silent! Neoformat ]], false)

-- Format SQL on save
vim.api.nvim_exec([[ autocmd BufWritePre *.sql :silent! Neoformat pg_format ]], false)

-- SQL tabs
vim.api.nvim_exec([[ autocmd BufRead *.sql set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab ]], false)

-- Format Python on save
vim.api.nvim_exec([[ autocmd BufWritePre *.py :silent! Neoformat ]], false)

-- Format Protobuf on save
vim.api.nvim_exec([[ autocmd BufWritePre *.proto :silent! Neoformat ]], false)

-- Format JS on save
vim.api.nvim_exec([[ autocmd BufWritePre *.js :silent! Neoformat ]], false)
vim.api.nvim_exec([[ autocmd BufWritePre *.jsx :silent! Neoformat ]], false)

vim.api.nvim_exec([[ autocmd BufWritePre *.css :silent! Neoformat ]], false)

-- Format Lua on save
vim.api.nvim_exec([[ autocmd BufWritePre *.lua :silent! Neoformat ]], false)

-- Format JSON on save
vim.api.nvim_exec([[ autocmd BufWritePre *.json :silent! Neoformat ]], false)

-- Format Tiltfile on save
vim.api.nvim_exec([[ autocmd BufWritePre Tiltfile :silent! Neoformat ]], false)

vim.api.nvim_exec(
    [[ 
    aug i3config_ft_detection
  au!
  au BufNewFile,BufRead ~/.config/i3/config set filetype=i3config
aug end ]],
    false
)

-- Load tilt file
vim.api.nvim_exec([[ autocmd BufRead Tiltfile set ft=tiltfile ]], false)
vim.api.nvim_exec([[ autocmd BufRead Tiltfile set syntax=python ]], false)
