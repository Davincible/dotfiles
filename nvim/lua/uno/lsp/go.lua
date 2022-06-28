require "go".setup(
    {
        goimport = "gopls", -- if set to 'gopls' will use golsp format
        gofmt = "gopls", -- if set to gopls will use golsp format
        max_line_len = 120,
        tag_transform = false,
        test_dir = "",
        comment_placeholder = "   ",
        lsp_cfg = false, -- false: use your own lspconfig
        lsp_gofumpt = true, -- true: set default gofmt in gopls format to gofumpt
        lsp_on_attach = true, -- use on_attach from go.nvim
        dap_debug = true,
        test_runner = "richgo"
    }
)

local lsp_installer_servers = require "nvim-lsp-installer.servers"

local server_available, requested_server = lsp_installer_servers.get_server("gopls")
if server_available then
    requested_server:on_ready(
        function()
            local opts = require "go.lsp".config() -- config() return the go.nvim gopls setup
            requested_server:setup(opts)
        end
    )
    if not requested_server:is_installed() then
        -- Queue the server to be installed
        requested_server:install()
    end
end

vim.cmd('command! Gofmt lua require("go.format").gofmt(true)')

vim.cmd("augroup go")
vim.cmd("autocmd!")
--  :GoBuild and :GoTestCompile')
vim.cmd("autocmd FileType go nmap <leader>gb  :GoBuild")
vim.cmd("autocmd FileType go nmap <leader>gr  :GoRun")
--  Show by default 4 spaces for a tab')
vim.cmd("autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=2 shiftwidth=2")
-- Import && format on save
vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua require('go.format').goimport() ]], false)

--  :GoTest')
vim.cmd("autocmd FileType go nmap <leader>gt  GoTest")
--  :GoRun
vim.cmd("autocmd FileType go nmap <Leader>gl GoLint")
vim.cmd("autocmd FileType go nmap <Leader>gc :lua require('go.comment').gen()")
vim.cmd("autocmd FileType go nmap <Leader>gs :GoFillStruct<CR>")

vim.cmd("au FileType go command! Gtn :TestNearest -v -tags=integration")
vim.cmd("au FileType go command! Gts :TestSuite -v -tags=integration")
vim.cmd("augroup END")
