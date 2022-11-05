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
