local telescope = require("telescope")
local actions = require("telescope.actions")
local my_pickers = require("uno.telescope-pickers")

require("trouble").setup()
local trouble = require("trouble.providers.telescope")

local M = {}

telescope.setup({
	defaults = {
		-- find_command = {'rg', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case', '--max-depth 5'},
		prompt_prefix = " ",
		-- prompt_prefix = " ",
		selection_caret = " ",
		entry_prefix = "  ",
		initial_mode = "insert",
		-- initial_mode = "insert",
		selection_strategy = "reset",
		sorting_strategy = "descending",
		layout_strategy = "horizontal",
		layout_config = {
			prompt_position = "bottom",
			-- preview_cutoff = 120,
			horizontal = { width = 0.8, mirror = false },
			vertical = { mirror = false },
		},
		-- file_sorter = require("telescope.sorters").get_fzy_sorter,
		file_ignore_patterns = {
			"node_modules/",
			"vendor/",
			".git/",
		},
		-- generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
		path_display = {
			shorten = {
				len = 3,
				exclude = { 1, -1 },
			},
		},
		winblend = 0,
		border = {},
		borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
		color_devicons = true,
		-- use_less = true,
		set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
		file_previewer = require("telescope.previewers").vim_buffer_cat.new,
		grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
		qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
		-- Developer configurations: Not meant for general override
		-- buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
		mappings = {
			i = {
				["<C-c>"] = actions.close,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<c-r>"] = require("trouble.providers.telescope").open_with_trouble,
				["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
				-- To disable a keymap, put [map] = false
				-- So, to not map "<C-n>", just put
				-- ["<c-x>"] = false,
				-- ["<esc>"] = actions.close,

				-- Otherwise, just set the mapping to the function that you want it to be.
				-- ["<C-i>"] = actions.select_horizontal,

				-- Add up multiple actions
				["<CR>"] = actions.select_default + actions.center,

				-- You can perform as many actions in a row as you like
				-- ["<CR>"] = actions.select_default + actions.center + my_cool_custom_action,
			},
			n = {
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<c-r>"] = require("trouble.providers.telescope").open_with_trouble,
				["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
				-- ["<C-i>"] = my_cool_custom_action,
			},
		},
	},
	extensions = {
		-- fzf = {
		-- 	fuzzy = true, -- false will only do exact matching
		-- 	override_generic_sorter = true, -- override the generic sorter
		-- 	override_file_sorter = true, -- override the file sorter
		-- 	case_mode = "smart_case", -- or "ignore_case" or "respect_case"
		-- },
		repo = {
			list = {
				search_dirs = {
					"~/Launchpad",
				},
			},
		},
		media_files = {
			-- filetypes whitelist
			-- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
			filetypes = { "png", "webp", "jpg", "jpeg", "pdf", "webm", "mp4", "mp3", "mkv" },
		},
		["ui-select"] = {
			require("telescope.themes").get_dropdown({}),
		},
	},
	pickers = {
		grep_in_folder = my_pickers.live_grep_in_folder,
		find_files = {
			find_command = {
				"fd",
				"--max-depth",
				"8",
				"--hidden",
				"--follow",
				"--type",
				"f",
				"--strip-cwd-prefix",
				"--follow",
				"--no-ignore-vcs",
			},
		},
	},
})

require("telescope").load_extension("fzy_native")
-- require("telescope").load_extension("fzf")
require("telescope").load_extension("projects") -- ahmedkhalf/project.nvim
require("telescope").load_extension("media_files")
require("telescope").load_extension("ui-select")
require("telescope").load_extension("tmuxinator")
require("telescope").load_extension("notify")
require("telescope").load_extension("file_browser")
require("telescope").load_extension("dap")
require("telescope").load_extension("workspaces")

-- Native
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { silent = true })
vim.keymap.set("n", "<leader>fT", ":Telescope<CR>", { silent = true })
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep, { silent = true })
vim.keymap.set("n", "<leader>fG", my_pickers.live_grep_in_folder, { silent = true })
vim.keymap.set("n", "<leader>fb", require("telescope.builtin").current_buffer_fuzzy_find, { silent = true })
vim.keymap.set("n", "<leader>fl", require("telescope.builtin").buffers, { silent = true })
vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags, { silent = true })
vim.keymap.set("n", "<leader>fr", require("telescope.builtin").lsp_references, { silent = true })
vim.keymap.set("n", "<leader>fd", require("telescope.builtin").lsp_definitions, { silent = true })
vim.keymap.set("n", "<leader>fs", require("telescope.builtin").symbols, { silent = true })
vim.keymap.set("n", "<C-p>", require("telescope.builtin").git_status, { silent = true })

-- Extensions
vim.keymap.set("n", "<leader>fw", require("telescope").extensions.workspaces.workspaces, { silent = true })
vim.keymap.set("n", "<leader>fm", require("telescope").extensions.media_files.media_files, { silent = true })
vim.keymap.set("n", "<leader>ft", require("telescope").extensions.file_browser.file_browser, { silent = true })
vim.keymap.set("n", "<leader>fn", require("telescope").extensions.notify.notify, { silent = true })
vim.keymap.set("n", "<leader>fp", require("telescope").extensions.repo.list, { silent = true })

-- Dap debug
vim.keymap.set("n", "<leader>lb", require("telescope").extensions.dap.list_breakpoints, { silent = true })
vim.keymap.set("n", "<leader>lv", require("telescope").extensions.dap.variables, { silent = true })
vim.keymap.set("n", "<leader>lf", require("telescope").extensions.dap.frames, { silent = true })
vim.keymap.set("n", "<leader>lc", require("telescope").extensions.dap.commands, { silent = true })
vim.keymap.set("n", "<leader>ls", require("telescope").extensions.dap.configurations, { silent = true })

return M
