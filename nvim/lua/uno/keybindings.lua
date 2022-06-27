-- Unbind
vim.api.nvim_set_keymap("n", "Q", "", {noremap = true, silent = true})
vim.api.nvim_set_keymap("v", "Q", "", {noremap = true, silent = true})

-- Delete without yanking
vim.api.nvim_set_keymap("n", "<leader>d", '"_d', {noremap = true})
vim.api.nvim_set_keymap("v", "<leader>d", '"_d', {noremap = true})

-- Paste on new line
vim.api.nvim_set_keymap("n", "<leader>p", "o<ESC>p", {noremap = true})
vim.api.nvim_set_keymap("v", "<leader>p", "o<ESC>p", {noremap = true})

-- write only if changed
vim.api.nvim_set_keymap("n", "<Leader>w", ":up<CR>", {noremap = true})
vim.api.nvim_set_keymap("v", "<Leader>w", ":up<CR>", {noremap = true})
-- quit (or close window)
vim.api.nvim_set_keymap("n", "<Leader>q", ":q<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("v", "<Leader>q", ":q<CR>", {noremap = true, silent = true})
-- use ZQ for :q! (quit & discard changes)
-- Discard all changed buffers & quit
vim.api.nvim_set_keymap("n", "<Leader>Q", ":qall!<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("v", "<Leader>Q", ":qall!<CR>", {noremap = true, silent = true})
-- write all and quit
vim.api.nvim_set_keymap("n", "<Leader>W", ":wqall<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("v", "<Leader>W", ":wqall<CR>", {noremap = true, silent = true})
-- Buffer stuff - <C-6> is toggle current and alt(last viewed)
-- go to next buffer
vim.api.nvim_set_keymap("n", "<Leader><right>", ":bn<CR>", {noremap = true, silent = true})
-- Doesn't work
vim.api.nvim_set_keymap("n", "<Leader>l", ":bn<CR>", {noremap = true, silent = true})
-- go to prev buffer
vim.api.nvim_set_keymap("n", "<Leader><left>", ":bp<CR>", {noremap = true, silent = true})
-- Doesn't work
vim.api.nvim_set_keymap("n", "<Leader>h", ":bp<CR>", {noremap = true, silent = true})

-- Move windows
vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", {noremap = true, silent = true})

-- Navigate Insert
-- vim.api.nvim_set_keymap('i', '<C-h>', '<C-o>h', {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('i', '<C-l>', '<C-o>l', {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('i', '<C-k>', '<C-o>k', {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('i', '<C-j>', '<C-o>j', {noremap = true, silent = true})

-- HTML stuf
-- Select inside tag, delete, select all tags, paste, format, beginning of line
vim.api.nvim_set_keymap("n", "<Leader>5", "vitdvatp:Neoformat<CR>^", {noremap = true, silent = true})

-- Restart LSP
vim.api.nvim_set_keymap("n", "<Leader>R", ":LspRestart<CR>", {noremap = true, silent = true})

-- Select all
vim.api.nvim_set_keymap("n", "<Leader>va", "ggVG", {noremap = true, silent = true})

-- Git stuff
vim.api.nvim_set_keymap("n", "<Leader>G", ":Git<CR>", {noremap = true, silent = true})

vim.keymap.set(
    {"i"},
    "<F16>",
    function()
        vim.cmd([[[ echo synIDattr(synID(line("."), col("."), 1), "name") ]])
    end
)
