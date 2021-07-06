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

    buf_set_keymap("n", "gD", "lua vim.lsp.buf.declaration()", opts)
    buf_set_keymap("n", "gd", "lua vim.lsp.buf.definition()", opts)
    buf_set_keymap("n", "K", "lua vim.lsp.buf.hover()", opts)
    buf_set_keymap("n", "gi", "lua vim.lsp.buf.implementation()", opts)
    buf_set_keymap("n", "<C-k>", "lua vim.lsp.buf.signature_help()", opts)
    buf_set_keymap("n", "<leader>wa", "lua vim.lsp.buf.add_workspace_folder()", opts)
    buf_set_keymap("n", "<leader>wr", "lua vim.lsp.buf.remove_workspace_folder()", opts)
    buf_set_keymap("n", "<leader>wl", "lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))", opts)
    buf_set_keymap("n", "<leader>D", "lua vim.lsp.buf.type_definition()", opts)
    buf_set_keymap("n", "<leader>rn", "lua vim.lsp.buf.rename()", opts)
    buf_set_keymap("n", "gr", "lua vim.lsp.buf.references()", opts)
    buf_set_keymap("n", "<leader>e", "lua vim.lsp.diagnostic.show_line_diagnostics()", opts)
    buf_set_keymap("n", "[d", "lua vim.lsp.diagnostic.goto_prev()", opts)
    buf_set_keymap("n", "]d", "lua vim.lsp.diagnostic.goto_next()", opts)
    buf_set_keymap("n", "<leader>q", "lua vim.lsp.diagnostic.set_loclist()", opts)

    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
        buf_set_keymap("n", "<leader>f", "lua vim.lsp.buf.formatting()", opts)
    elseif client.resolved_capabilities.document_range_formatting then
        buf_set_keymap("n", "<leader>f", "lua vim.lsp.buf.range_formatting()", opts)
    end
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

-- replace the default lsp diagnostic letters with prettier symbols
vim.fn.sign_define("LspDiagnosticsSignError",       {text = "", numhl = "LspDiagnosticsDefaultError"})
vim.fn.sign_define("LspDiagnosticsSignWarning",     {text = "", numhl = "LspDiagnosticsDefaultWarning"})
vim.fn.sign_define("LspDiagnosticsSignInformation", {text = "", numhl = "LspDiagnosticsDefaultInformation"})
vim.fn.sign_define("LspDiagnosticsSignHint",        {text = "", numhl = "LspDiagnosticsDefaultHint"})
