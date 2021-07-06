require("go").setup()

vim.cmd('command! Gofmt lua require("go.format").gofmt(true)')

vim.cmd("augroup go")
vim.cmd("autocmd!")
--  :GoBuild and :GoTestCompile')
vim.cmd("autocmd FileType go nmap <leader>gb  :GoBuild")
vim.cmd("autocmd FileType go nmap <leader>gr  :GoRun")
--  Show by default 4 spaces for a tab')
vim.cmd("autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4")
vim.cmd("autocmd BufWritePre *.go :silent! lua require('go.format').gofmt()")
--  :GoTest')
vim.cmd("autocmd FileType go nmap <leader>gt  GoTest")
--  :GoRun
vim.cmd("autocmd FileType go nmap <Leader>gl GoLint")
vim.cmd("autocmd FileType go nmap <Leader>gc :lua require('go.comment').gen()")

vim.cmd("au FileType go command! Gtn :TestNearest -v -tags=integration")
vim.cmd("au FileType go command! Gts :TestSuite -v -tags=integration")
vim.cmd("augroup END")
