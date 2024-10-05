-- Unbind
vim.api.nvim_set_keymap("n", "Q", "", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "Q", "", { noremap = true, silent = true })

-- Delete without yanking
-- vim.api.nvim_set_keymap("n", "<leader>d", '"_d', { noremap = true })
-- vim.api.nvim_set_keymap("v", "<leader>d", '"_d', { noremap = true })

-- Paste on new line
vim.api.nvim_set_keymap("n", "<leader>p", "o<ESC>p", { noremap = true })
vim.api.nvim_set_keymap("v", "<leader>p", "o<ESC>p", { noremap = true })

-- Scroll wrapped lines
vim.api.nvim_set_keymap("n", "j", "gj", { noremap = true })
vim.api.nvim_set_keymap("n", "k", "gk", { noremap = true })
vim.api.nvim_set_keymap("n", "gk", "k", { noremap = true })
vim.api.nvim_set_keymap("n", "gk", "k", { noremap = true })

-- write only if changed
vim.api.nvim_set_keymap("n", "<Leader>w", ":up<CR>", { noremap = true })
vim.api.nvim_set_keymap("v", "<Leader>w", ":up<CR>", { noremap = true })
-- quit (or close window)
vim.api.nvim_set_keymap("n", "<Leader>q", ":q<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<Leader>q", ":q<CR>", { noremap = true, silent = true })
-- use ZQ for :q! (quit & discard changes)
-- Discard all changed buffers & quit
vim.api.nvim_set_keymap("n", "<Leader>Q", ":qall!<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<Leader>Q", ":<C-c>qall!<CR>", { noremap = true, silent = true })
-- write all and quit
vim.api.nvim_set_keymap("n", "<Leader>W", ":wqall<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<Leader>W", ":wqall<CR>", { noremap = true, silent = true })

-- Buffer stuff - <C-6> is toggle current and alt(last viewed)
vim.api.nvim_set_keymap("n", "<Leader>bn", ":bn<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>bp", ":bp<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader><right>", ":bn<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader><left>", ":bp<CR>", { noremap = true, silent = true })

-- Move windows
-- vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", {noremap = true, silent = true})
-- vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", {noremap = true, silent = true})
-- vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", {noremap = true, silent = true})
-- vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", {noremap = true, silent = true})

-- Navigate Insert
-- vim.api.nvim_set_keymap('i', '<C-h>', '<C-o>h', {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('i', '<C-l>', '<C-o>l', {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('i', '<C-k>', '<C-o>k', {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('i', '<C-j>', '<C-o>j', {noremap = true, silent = true})

-- HTML stuf
-- Select inside tag, delete, select all tags, paste, format, beginning of line
vim.api.nvim_set_keymap("n", "<Leader>5", "vitdvatp:Neoformat<CR>^", { noremap = true, silent = true })

-- Restart LSP
vim.api.nvim_set_keymap("n", "<Leader>R", ":LspRestart<CR>", { noremap = true, silent = true })

-- Select all
vim.api.nvim_set_keymap("n", "<Leader>va", "ggVG", { noremap = true, silent = true })

-- Git stuff
vim.api.nvim_set_keymap("n", "<Leader>G", ":Git<CR>", { noremap = true, silent = true })

-- Codelens
vim.api.nvim_set_keymap("n", "<Leader>cl", ":lua vim.lsp.codelens.run()<CR>", { noremap = true, silent = true })

-- Debugging
vim.api.nvim_set_keymap(
	"n",
	"<Leader>db",
	":lua require'dap'.toggle_breakpoint()<CR>",
	{ noremap = true, silent = true }
)

local bind = require("go.keybind")
bind.nvim_load_mapping({
	-- DAP --
	["<Leader>dr"] = { f = require("go.dap").run, desc = "run" },
	["<Leader>dc"] = { f = require("dap").continue, desc = "continue" },
	["<Leader>dn"] = { f = require("dap").step_over, desc = "step_over" },
	["<Leader>ds"] = { f = require("dap").step_into, desc = "step_into" },
	["<Leader>do"] = { f = require("dap").step_out, desc = "step_out" },
	["<Leader>dS"] = { f = require("go.dap").stop, desc = "stop" },
	["<Leader>du"] = { f = require("dap").up, desc = "up" },
	["<Leader>dd"] = { f = require("dap").down, desc = "down" },
	["<Leader>dC"] = { f = require("dap").run_to_cursor, desc = "run_to_cursor" },
	["<Leader>db"] = { f = require("dap").toggle_breakpoint, desc = "toggle_breakpoint" },
	["<Leader>dP"] = { f = require("dap").pause, desc = "pause" },
	["<F9>"] = { f = require("dap").continue, desc = "continue" },
	["<F10>"] = { f = require("dap").step_over, desc = "step_over" },
	["<F11>"] = { f = require("dap").step_into, desc = "step_into" },
	["<F12>"] = { f = require("dap").step_out, desc = "step_out" },
})
vim.api.nvim_set_keymap("n", "<Leader>dR", ":GoDebug -R<CR>", { noremap = true, silent = true })

-- nnoremap <silent> <F5> <Cmd>lua require'dap'.continue()<CR>
-- nnoremap <silent> <F10> <Cmd>lua require'dap'.step_over()<CR>
-- nnoremap <silent> <F11> <Cmd>lua require'dap'.step_into()<CR>
-- nnoremap <silent> <F12> <Cmd>lua require'dap'.step_out()<CR>
-- nnoremap <silent> <Leader>b <Cmd>lua require'dap'.toggle_breakpoint()<CR>
-- nnoremap <silent> <Leader>B <Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
-- nnoremap <silent> <Leader>lp <Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
-- nnoremap <silent> <Leader>dr <Cmd>lua require'dap'.repl.open()<CR>
-- nnoremap <silent> <Leader>dl <Cmd>lua require'dap'.run_last()<CR>

-- Get highlight group
vim.keymap.set({ "i", "n" }, "<F16>", function()
	vim.cmd([[[ echo synIDattr(synID(line("."), col("."), 1), "name") ]])
end)

-- Terminal stuff
vim.api.nvim_set_keymap("t", "<C-`>", "<C-\\><C-N>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>t", ":ToggleTerm<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>tv", ":vsplit<bar>term<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>ts", ":split<bar>term<CR>", { noremap = true, silent = true })

-- Translate
vim.api.nvim_set_keymap("v", "<Leader>t", ":Translate EN -output=replace<CR>", { noremap = true, silent = true })

-- local maps = {
--   n =    {
--     ["<F10>"] = ":10sp term://fish<CR>i",
--     ["<F12>"] = ":make<CR>",
--     ["<F1>"] = "<nop>",
--     ["<F8>"] = ":NvimTreeToggle<CR>",
--     ...
--   },
--   i = {
--     ["<S-Tab>"] = {map=[[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], opts={noremap=true, expr=true}},
--     ["<Tab>"] = {map=[[pumvisible() ? "\<C-n>" : "\<Tab>"]], opts={noremap=true, expr=true}},
--     ["<c-c>"] = "<ESC>",
--     ...
--   },
--   t = {
--     ["<Esc>"] = [[<C-\><C-n>]],
--   },
--   c = {
--     ["w!!"] = {map="w !sudo sponge %", opts={}}
--   }
-- }
--
-- for mode, mappings in pairs(maps) do
--   for keys, mapping in pairs(mappings) do
--     if (type(mapping) == "table") then
--       vim.api.nvim_set_keymap(mode, keys, mapping.map, mapping.opts)
--     else
--       vim.api.nvim_set_keymap(mode, keys, mapping, {noremap=true})
--     end
--   end
-- end

-- GitHub Co-Pilot
vim.g.copilot_no_tab_map = true

vim.api.nvim_set_keymap("i", "<S-CR>", 'copilot#Accept("\\<CR>")', { expr = true, silent = true })

local function SuggestOneCharacter()
	local suggestion = vim.fn["copilot#Accept"]("")
	local bar = vim.fn["copilot#TextQueuedForInsertion"]()
	return bar:sub(1, 1)
end

local function SuggestOneWord()
	local suggestion = vim.fn["copilot#Accept"]("")
	local bar = vim.fn["copilot#TextQueuedForInsertion"]()
	return vim.fn.split(bar, [[[ .]\zs]])[1]
end

local function accept_line()
	vim.fn["copilot#Accept"]("")
	local bar = vim.fn["copilot#TextQueuedForInsertion"]()
	return vim.fn.split(bar, [[[\n]\zs]])[1]
end

local map = vim.keymap.set
map("i", "<C-l>", SuggestOneCharacter, { expr = true, remap = false })
map("i", "<C-left>", SuggestOneWord, { expr = true, remap = false })
map("i", "<M-l>", accept_line, { expr = true, remap = false })

-- Ufo keybindings
map("n", "zO", require("ufo").openAllFolds)
map("n", "zC", require("ufo").closeAllFolds)
map("n", "fO", require("ufo").openAllFolds)
map("n", "fC", require("ufo").closeAllFolds)
map("n", "fo", ":foldopen<CR>", { noremap = true, silent = true })
map("n", "fc", ":foldclose<CR>", { noremap = true, silent = true })
map("n", "zr", require("ufo").openFoldsExceptKinds)
map("n", "zm", require("ufo").closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)
map("n", "fm", require("ufo").closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)
map("n", "K", function()
	local winid = require("ufo").peekFoldedLinesUnderCursor()
	if not winid then
		-- choose one of coc.nvim and nvim lsp
		vim.fn.CocActionAsync("definitionHover") -- coc.nvim
		vim.lsp.buf.hover()
	end
end)
