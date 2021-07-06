call plug#begin('~/.vim/plugged')
" -- Telescope, fzf replacement fuzzy scanner
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

" -- Theming
Plug 'dylanaraps/wal.vim'
Plug 'deviantfero/wpgtk.vim'
Plug 'chrisbra/Colorizer'

" -- Software Devlopment
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'ekalinin/Dockerfile.vim'
" Plug 'darrikonn/vim-gofmt'

" -- Nvim LSP
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'kabouzeid/nvim-lspinstall'
Plug 'onsails/lspkind-nvim'

call plug#end()

filetype plugin indent on

" ---- Set tab options
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent

" ---- Other options
set exrc                " -- auto source .vimrc in project directories if you do `nvim .`
set guicursor=          " -- make cursor a block
set relativenumber      " -- set the relative numbering
set nu                  " -- set the current line number instead of 0 (relative number)
set nohlsearch          " -- after you're done, don't highlight the search result
set hidden              " -- keep buffer around if you quit, even if you don't save it
set noerrorbells        " -- no beep on errors
set nowrap              " -- don't wrap the text, instead extend the screen
set ignorecase          " -- case insensitive search
set smartcase           " -- case sensitive if you use a capital
set incsearch           " -- highlight as you search, instead of only when enter is pressed
set scrolloff=12         " -- start scrolling at an offset of 8
set completeopt=menuone,noinsert
set colorcolumn=80      " -- line at 80 wide
set signcolumn=yes      " -- column on the left that shows error signs
set cmdheight=2         " -- Give more space for displaying messages
set updatetime=50       " -- Default is 4000ms, bad user experience
" set shortmess+=c      " -- Don't pass messages to |ins-completion-menu| ??
set mouse=a             " -- enable mouse support
set clipboard=unnamedplus
syntax on
" hi clear SignColumn   " -- not sure if this is useful

" Nice menu when typing `:find *.py`
set wildmode=longest,list,full
set wildmenu
" Ignore files
set wildignore+=*.pyc
set wildignore+=*_build/*
set wildignore+=**/coverage/*
set wildignore+=**/node_modules/*
set wildignore+=**/android/*
set wildignore+=**/ios/*
set wildignore+=**/.git/*


" ---- History options
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile

" ---- Theming
" set termguicolors       " -- use 24 bit colors
hi Normal ctermbg=none guibg=none
colorscheme wpgtkAlt         " -- colorscheme pywal
hi ColorColumn ctermbg=4 guibg=#4d0000
let g:colorizer_auto_color = 1

" ---- Remapping
let mapleader = " "

" delete without yanking
"nnoremap <leader>d "_d
"vnoremap <leader>d "_d

" -- Telescope
" nnoremap <leader>ps
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <C-p> :lua require('telescope.builtin').git_files()<CR>

lua << EOF

local actions = require('telescope.actions')
require('telescope').setup {
    defaults = {
        file_sorter = require('telescope.sorters').get_fzy_sorter,
        prompt_prefix = ' >',
        color_devicons = true,
av
        file_previewer   = require('telescope.previewers').vim_buffer_cat.new,
        grep_previewer   = require('telescope.previewers').vim_buffer_vimgrep.new,
        qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,

        mappings = {
            i = {
                ["<C-x>"] = false,
                ["<C-q>"] = actions.send_to_qflist,
            },
        }
    },
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        }
    }
}

-- require("telescope").load_extension("git_worktree")
require('telescope').load_extension('fzy_native')

EOF

" ---- LSP Config
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <C-n> <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> <C-p> <cmd>lua vim.lsp.diagnostic.goto_next()<CR>

autocmd BufWritePre *.js lua vim.lsp.buf.formatting_sync(nil, 100)
autocmd BufWritePre *.jsx lua vim.lsp.buf.formatting_sync(nil, 100)
autocmd BufWritePre *.py lua vim.lsp.buf.formatting_sync(nil, 100)

" -- compe autocomplete
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })



lua << EOF

vim.o.completeopt = "menuone,noinsert,noselect"

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  resolve_timeout = 800;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    ultisnips = true;
  };
}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end


_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif vim.fn.call("vsnip#available", {1}) == 1 then
    return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  else
    -- If <S-Tab> is not working in your terminal, change it to <C-h>
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

local function on_attach()
    -- TODO: TJ told me to do this and I should do it because he is Telescopic
    -- "Big Tech" "Cash Money" Johnson
end

local function setup_servers()
  require'lspinstall'.setup()
  local servers = require'lspinstall'.installed_servers()
  for _, server in pairs(servers) do
    require'lspconfig'[server].setup{}
  end
end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require'lspinstall'.post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end


-- require'lspconfig'.bashls.setup{}
-- require'lspconfig'.pyright.setup{}
-- require'lspconfig'.tsserver.setup{ on_attach=on_attach }
-- require'lspconfig'.clangd.setup {
--     on_attach = on_attach,
--     root_dir = function() return vim.loop.cwd() end
-- }
-- 
-- require'lspconfig'.pyls.setup{ on_attach=on_attach }
-- 
-- require'lspconfig'.gopls.setup{
--     on_attach=on_attach,
--     cmd = {"gopls", "serve"},
--     settings = {
--         gopls = {
--             analyses = {
--                 unusedparams = true,
--             },
--             staticcheck = true,
--         },
--     },
-- }

EOF

let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

" Errors in Red
hi LspDiagnosticsVirtualTextError guifg=Red ctermfg=Red
" Warnings in Yellow
hi LspDiagnosticsVirtualTextWarning guifg=Yellow ctermfg=Yellow
" Info and Hints in White
hi LspDiagnosticsVirtualTextInformation guifg=White ctermfg=White
hi LspDiagnosticsVirtualTextHint guifg=White ctermfg=White
hi Pmenu ctermbg=4
hi PmenuSel ctermbg=1



" Underline the offending code
hi LspDiagnosticsUnderlineError guifg=NONE ctermfg=NONE cterm=underline gui=underline
hi LspDiagnosticsUnderlineWarning guifg=NONE ctermfg=NONE cterm=underline gui=underline
hi LspDiagnosticsUnderlineInformation guifg=NONE ctermfg=NONE cterm=underline gui=underline
hi LspDiagnosticsUnderlineHint guifg=NONE ctermfg=NONE cterm=underline gui=underline

lua << EOF
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
 vim.lsp.diagnostic.on_publish_diagnostics, {
   -- Enable underline, use default values
   underline = true,
   -- Enable virtual text only on Warning or above, override spacing to 2
   virtual_text = {
     spacing = 2,
     severity_limit = "Warning",
   },
 }
)
EOF

autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()

" -- lsp icons

lua << EOF

require'lspconfig'.sumneko_lua.setup {
    -- ... other configs
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
}

require('lspkind').init({
    -- enables text annotations
    --
    -- default: true
    with_text = true,

    -- default symbol map
    -- can be either 'default' or
    -- 'codicons' for codicon preset (requires vscode-codicons font installed)
    --
    -- default: 'default'
    preset = 'codicons',

    -- override preset symbols
    --
    -- default: {}
    symbol_map = {
      Text = '',
      Method = 'ƒ',
      Function = '',
      Constructor = '',
      Variable = '',
      Class = '',
      Interface = 'ﰮ',
      Module = '',
      Property = '',
      Unit = '',
      Value = '',
      Enum = '了',
      Keyword = '',
      Snippet = '﬌',
      Color = '',
      File = '',
      Folder = '',
      EnumMember = '',
      Constant = '',
      Struct = ''
    },
})

EOF
" -- Undotree
nnoremap <leader>u :UndotreeShow<cr>


" delete without yanking
nnoremap <leader>d "_d
vnoremap <leader>d "_d

" replace currently selected text with default register
" without yanking it
vnoremap <leader>p "_dp


