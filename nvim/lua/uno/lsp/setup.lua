function on_attach(client, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Mappings.
    local opts = {noremap = true, silent = true}

    buf_set_keymap("n", "gD",         ":lua vim.lsp.buf.declaration()<CR>", opts)
    buf_set_keymap("n", "gd",         ":lua vim.lsp.buf.definition()<CR>", opts)
    buf_set_keymap("n", "K",          ":lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap("n", "gi",         ":lua vim.lsp.buf.implementation()<CR>", opts)
    buf_set_keymap("n", "<C-k>",      ":lua vim.lsp.buf.signature_help()<CR>", opts)
    buf_set_keymap("n", "<leader>wa", ":lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
    buf_set_keymap("n", "<leader>wr", ":lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
    buf_set_keymap("n", "<leader>wl", ":lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
    buf_set_keymap("n", "<leader>D",  ":lua vim.lsp.buf.type_definition()<CR>", opts)
    buf_set_keymap("n", "<leader>rn", ":lua vim.lsp.buf.rename()<CR>", opts)
    buf_set_keymap("n", "gr",         ":lua vim.lsp.buf.references()<CR>", opts)
    buf_set_keymap("n", "<leader>e",  ":lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
    buf_set_keymap("n", "[d",         ":lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
    buf_set_keymap("n", "]d",         ":lua vim.lsp.diagnostic.goto_next()<CR>", opts)
    buf_set_keymap("n", "<leader>q",  ":lua vim.lsp.diagnostic.set_loclist()<CR>", opts)

    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
        buf_set_keymap("n", "<leader>f", ":lua vim.lsp.buf.formatting()<CR>", opts)
    elseif client.resolved_capabilities.document_range_formatting then
        buf_set_keymap("n", "<leader>f", ":lua vim.lsp.buf.range_formatting()<CR>", opts)
    end

    require "lsp_signature".on_attach({
      bind = true, -- This is mandatory, otherwise border config won't get registered.
      handler_opts = {
        border = "single"
      },
      use_lspsaga = true,
    })
end

-- lspInstall + lspconfig stuff

local function setup_servers()
    require "lspinstall".setup()

    local lspconf = require("lspconfig")
    local servers = require "lspinstall".installed_servers()

    for _, lang in pairs(servers) do
        if lang ~= "lua" then
            lspconf[lang].setup {
                on_attach = on_attach,
                root_dir = vim.loop.cwd
            }
        elseif lang == "lua" then
            lspconf[lang].setup {
                root_dir = function()
                    return vim.loop.cwd()
                end,
		on_attach = function(client, buffnr)
		  require "lsp_signature".on_attach({
		      bind = true, -- This is mandatory, otherwise border config won't get registered.
		      handler_opts = {
			border = "single"
		      },
		      use_lspsaga = true,
		    })

                  vim.bo.tabstop      = 2
                  vim.bo.softtabstop  = 2
                  vim.bo.shiftwidth   = 2
		end,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = {"vim", "use"}
                        },
                        workspace = {
                            preloadFileSize = 1000,
                            library = {
                                [vim.fn.expand("$VIMRUNTIME/lua")] = true
                            }
                        },
                        telemetry = {
                            enable = false
                        }
                    }
                }
            }
        end
    end
end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require "lspinstall".post_install_hook = function()
    setup_servers() -- reload installed servers
    vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end

-- LSP Saga
require('lspsaga').init_lsp_saga({
  use_saga_diagnostic_sign = true,
  error_sign = '',
  warn_sign = '',
  hint_sign = '',
  infor_sign = '',
  dianostic_header_icon = '   ',
  code_action_icon = ' ',
  code_action_prompt = {
    enable = true,
    sign = true,
    sign_priority = 20,
    virtual_text = true,
  },
  finder_definition_icon = '  ',
  finder_reference_icon = '  ',
  max_preview_lines = 10, -- preview lines of lsp_finder and definition preview
  finder_action_keys = {
    open = 'o', vsplit = 's',split = 'i',quit = 'q',scroll_down = '<C-f>', scroll_up = '<C-b>' -- quit can be a table
  },
  code_action_keys = {
    quit = 'q',exec = '<CR>'
  },
  rename_action_keys = {
    quit = '<C-c>',exec = '<CR>'  -- quit can be a table
  },
  definition_preview_icon = '  ',
  -- "single" "double" "round" "plus"
  border_style = "single",
  rename_prompt_prefix = '➤',
  -- if you don't use nvim-lspconfig you must pass your server name and
  -- the related filetypes into this table
  -- like server_filetype_map = {metals = {'sbt', 'scala'}}
  -- server_filetype_map = {}
})

vim.api.nvim_set_keymap('n', 'gh', ":lua require'lspsaga.provider'.lsp_finder()<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>ca', ":lua require('lspsaga.codeaction').code_action()<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '<Leader>ca', ":<C-U>lua require('lspsaga.codeaction').range_code_action()<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'H', ":lua require('lspsaga.hover').render_hover_doc()<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-f>', ":lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-b>', ":lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'gs', ":lua require('lspsaga.signaturehelp').signature_help()<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>gd', ":lua require'lspsaga.provider'.preview_definition()<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>cd', ":lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>", {noremap = true, silent = true})

-- replace the default lsp diagnostic letters with prettier symbols
vim.fn.sign_define("LspDiagnosticsSignError",       {text = "", numhl = "LspDiagnosticsDefaultError"})
vim.fn.sign_define("LspDiagnosticsSignWarning",     {text = "", numhl = "LspDiagnosticsDefaultWarning"})
vim.fn.sign_define("LspDiagnosticsSignInformation", {text = "", numhl = "LspDiagnosticsDefaultInformation"})
vim.fn.sign_define("LspDiagnosticsSignHint",        {text = "", numhl = "LspDiagnosticsDefaultHint"})
