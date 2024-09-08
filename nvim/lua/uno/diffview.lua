local cb = require("diffview.config").diffview_callback
local actions = require("diffview.actions")

require("diffview").setup({
	diff_binaries = false, -- Show diffs for binaries
	enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
	use_icons = true, -- Requires nvim-web-devicons
	icons = {
		-- Only applies when use_icons is true.
		folder_closed = "",
		folder_open = "",
	},
	signs = {
		fold_closed = "",
		fold_open = "",
	},
	file_panel = {
		with_config = {
			position = "left", -- One of 'left', 'right', 'top', 'bottom'
			width = 35, -- Only applies when position is 'left' or 'right'
			height = 10, -- Only applies when position is 'top' or 'bottom'
		},
		listing_style = "tree", -- One of 'list' or 'tree'
		tree_options = {
			-- Only applies when listing_style is 'tree'
			flatten_dirs = true,
			folder_statuses = "always", -- One of 'never', 'only_folded' or 'always'.
		},
	},
	file_history_panel = {
		with_config = {
			position = "bottom",
			width = 35,
			height = 16,
		},
	},
	default_args = {
		-- Default args prepended to the arg-list for the listed commands
		DiffviewOpen = {},
		DiffviewFileHistory = {},
	},
	key_bindings = {
		keymaps = {
			disable_defaults = false,
			view = {
				["<tab>"] = actions.select_next_entry,
				["<s-tab>"] = actions.select_prev_entry,
				["gf"] = actions.goto_file,
				["<C-w><C-f>"] = actions.goto_file_split,
				["<C-w>gf"] = actions.goto_file_tab,
				["<leader>e"] = actions.focus_files,
				["<leader>b"] = actions.toggle_files,
				["g<C-x>"] = actions.cycle_layout,
				["[x"] = actions.prev_conflict,
				["]x"] = actions.next_conflict,
				["<leader>co"] = actions.conflict_choose("ours"),
				["<leader>ct"] = actions.conflict_choose("theirs"),
				["<leader>cb"] = actions.conflict_choose("base"),
				["<leader>ca"] = actions.conflict_choose("all"),
				["dx"] = actions.conflict_choose("none"),
			},
			diff1 = {},
			diff2 = {},
			diff3 = {
				{ { "n", "x" }, "2do", actions.diffget("ours") },
				{ { "n", "x" }, "3do", actions.diffget("theirs") },
			},
			diff4 = {
				{ { "n", "x" }, "1do", actions.diffget("base") },
				{ { "n", "x" }, "2do", actions.diffget("ours") },
				{ { "n", "x" }, "3do", actions.diffget("theirs") },
			},
			file_panel = {
				["j"] = actions.next_entry,
				["<down>"] = actions.next_entry,
				["k"] = actions.prev_entry,
				["<up>"] = actions.prev_entry,
				["<cr>"] = actions.select_entry,
				["o"] = actions.select_entry,
				["<2-LeftMouse>"] = actions.select_entry,
				["-"] = actions.toggle_stage_entry,
				["S"] = actions.stage_all,
				["U"] = actions.unstage_all,
				["X"] = actions.restore_entry,
				["L"] = actions.open_commit_log,
				["<c-b>"] = actions.scroll_view(-0.25),
				["<c-f>"] = actions.scroll_view(0.25),
				["<tab>"] = actions.select_next_entry,
				["<s-tab>"] = actions.select_prev_entry,
				["gf"] = actions.goto_file,
				["<C-w><C-f>"] = actions.goto_file_split,
				["<C-w>gf"] = actions.goto_file_tab,
				["i"] = actions.listing_style,
				["f"] = actions.toggle_flatten_dirs,
				["R"] = actions.refresh_files,
				["<leader>e"] = actions.focus_files,
				["<leader>b"] = actions.toggle_files,
				["g<C-x>"] = actions.cycle_layout,
				["[x"] = actions.prev_conflict,
				["]x"] = actions.next_conflict,
			},
			file_history_panel = {
				["g!"] = actions.options,
				["<C-A-d>"] = actions.open_in_diffview,
				["y"] = actions.copy_hash,
				["L"] = actions.open_commit_log,
				["zR"] = actions.open_all_folds,
				["zM"] = actions.close_all_folds,
				["j"] = actions.next_entry,
				["<down>"] = actions.next_entry,
				["k"] = actions.prev_entry,
				["<up>"] = actions.prev_entry,
				["<cr>"] = actions.select_entry,
				["o"] = actions.select_entry,
				["<2-LeftMouse>"] = actions.select_entry,
				["<c-b>"] = actions.scroll_view(-0.25),
				["<c-f>"] = actions.scroll_view(0.25),
				["<tab>"] = actions.select_next_entry,
				["<s-tab>"] = actions.select_prev_entry,
				["gf"] = actions.goto_file,
				["<C-w><C-f>"] = actions.goto_file_split,
				["<C-w>gf"] = actions.goto_file_tab,
				["<leader>e"] = actions.focus_files,
				["<leader>b"] = actions.toggle_files,
				["g<C-x>"] = actions.cycle_layout,
			},
			option_panel = {
				["<tab>"] = actions.select_entry,
				["q"] = actions.close,
			},
		},
	},
})
