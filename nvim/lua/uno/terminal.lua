require("toggleterm").setup({
	-- size can be a number or function which is passed the current terminal
	size = 20,
	open_mapping = [[<c-\>]],
	hide_numbers = true, -- hide the number column in toggleterm buffers
	shade_filetypes = {},
	shade_terminals = true,
	shading_factor = "1", -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
	start_in_insert = true,
	insert_mappings = true, -- whether or not the open mapping applies in insert mode
	persist_size = true,
	direction = "horizontal",
	close_on_exit = true, -- close the terminal window when the process exits
	shell = vim.o.shell, -- change the default shell
	-- This field is only relevant if direction is set to 'float'
})

-- Lazygit
local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({
	cmd = "lazygit",
	hidden = true,
	direction = "float",
	-- function to run on opening the terminal
	on_open = function(term)
		vim.cmd("startinsert!")
		vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
	end,
	-- function to run on closing the terminal
	on_close = function(term)
		vim.cmd("startinsert!")
	end,
	float_opts = {
		width = 175,
		height = 50,
		border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
	},
})

-- vim.o.lines
-- vim.o.columns

local btm = Terminal:new({
	cmd = "btm",
	hidden = false,
	direction = "float",
	on_open = function(term)
		vim.cmd("startinsert!")
		vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
	end,
	on_close = function(term)
		vim.cmd("startinsert!")
	end,
	float_opts = {
		width = 175,
		height = 50,
		border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
	},
})

local zsh = Terminal:new({
	cmd = "zsh",
	hidden = false,
	direction = "float",
	on_open = function(term)
		vim.cmd("startinsert!")
		vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
	end,
	on_close = function(term)
		vim.cmd("startinsert!")
	end,
	float_opts = {
		width = 175,
		height = 50,
		border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
	},
})

local gdu = Terminal:new({
	cmd = "gdu",
	hidden = false,
	direction = "float",
	on_open = function(term)
		vim.cmd("startinsert!")
		vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
	end,
	on_close = function(term)
		vim.cmd("startinsert!")
	end,
	float_opts = {
		width = 175,
		height = 50,
		border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
	},
})

function _lazygit_toggle()
	lazygit:toggle()
end

function _btm_toggle()
	btm:toggle()
end

function _zsh_toggle()
	zsh:toggle()
end

function _gdu_toggle()
	gdu:toggle()
end

vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>bt", "<cmd>lua _btm_toggle()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>T", "<cmd>lua _zsh_toggle()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>du", "<cmd>lua _gdu_toggle()<CR>", { noremap = true, silent = true })
