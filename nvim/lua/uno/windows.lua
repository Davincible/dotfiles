-- require("windows").setup({
-- 	autowidth = { --		       |windows.autowidth|
-- 		enable = true,
-- 		winwidth = 5, --		        |windows.winwidth|
-- 		filetype = { --	      |windows.autowidth.filetype|
-- 			help = 2,
-- 		},
-- 	},
-- 	ignore = { --			  |windows.ignore|
-- 		buftype = { "quickfix" },
-- 		filetype = { "NvimTree", "Outline", "neo-tree", "undotree", "gundo" },
-- 	},
-- 	animation = {
-- 		enable = false,
-- 	},
-- })
--
-- vim.keymap.set("n", "<C-w>m", ":WindowsMaximize<CR>", { silent = true })

require("focus").setup({
	excluded_filetypes = { "toggleterm", "term" },
	treewidth = 35,
	quickfixheight = 10,
	compatible_filetrees = { "Outline", "nvimtree", "nerdtree", "chadtree", "fern" },
})

local ignore_filetypes = { 'neo-tree', "toggleterm", "term", "NvimTree" }
local ignore_buftypes = { 'nofile', 'prompt', 'popup' }

local augroup =
    vim.api.nvim_create_augroup('FocusDisable', { clear = true })

vim.api.nvim_create_autocmd('WinEnter', {
    group = augroup,
    callback = function(_)
        if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
            vim.b.focus_disable = true
        end
    end,
    desc = 'Disable focus autoresize for BufType',
})

vim.api.nvim_create_autocmd('FileType', {
    group = augroup,
    callback = function(_)
        if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
            vim.b.focus_disable = true
        end
    end,
    desc = 'Disable focus autoresize for FileType',
})
