local snore =     { noremap = true, silent = true }

vim.api.nvim_set_keymap( "v", "<F1>", ":<c-u>HSHighlight 1<CR>", snore)
vim.api.nvim_set_keymap( "v", "<F2>", ":<c-u>HSHighlight 2<CR>", snore)
vim.api.nvim_set_keymap( "v", "<F3>", ":<c-u>HSHighlight 3<CR>", snore)
vim.api.nvim_set_keymap( "v", "<F4>", ":<c-u>HSHighlight 4<CR>", snore)
vim.api.nvim_set_keymap( "v", "<F5>", ":<c-u>HSRmHighlight<CR>", snore)
vim.api.nvim_set_keymap( "v", "<F6>", ":<c-u>HSRmHighlight rm_all<CR>", snore)
