local ts_config = require("nvim-treesitter.configs")

ts_config.setup({
	auto_install = true,
	sync_install = false,
	ensure_installed = {
		"javascript",
		"typescript",
		"dockerfile",
		"tsx",
		"html",
		"css",
		"bash",
		"lua",
		"json",
		"python",
		"yaml",
		"go",
		"gomod",
		"gowork",
		"http",
		"r",
		"hcl",
		"regex",
		"latex",
		"php",
		"scss",
		"make",
		"markdown",
		"proto",
		"sql",
		"nix",
	},
	-- This doesn't fix it
	-- indent = {
	-- 	enable = true,
	-- 	disable = { "python" },
	-- },
	highlight = {
		enable = true,
		disable = { "python" },
		use_languagetree = true,
		custom_captures = {
			-- Highlight the @foo.bar capture group with the "Identifier" highlight group.
			["function.decorator"] = "TSDecorator",
			["docstring"] = "TSDocString",
		},
	},
	autopairs = {
		enable = true,
	},
})

-- require("nvim-treesitter.configs").setup({
-- 	incremental_selection = {
-- 		enable = enable,
-- 		keymaps = {
-- 			-- mappings for incremental selection (visual mappings)
-- 			init_selection = "gnn", -- maps in normal mode to init the node/scope selection
-- 			node_incremental = "grn", -- increment to the upper named parent
-- 			scope_incremental = "grc", -- increment to the upper scope (as defined in locals.scm)
-- 			node_decremental = "grm", -- decrement to the previous node
-- 		},
-- 		context_commentstring = {
-- 			enable = true,
-- 			config = {
-- 				go = "// %s",
-- 			},
-- 		},
-- 	},
--
-- 	textobjects = {
-- 		-- syntax-aware textobjects
-- 		enable = enable,
-- 		lsp_interop = {
-- 			enable = enable,
-- 			peek_definition_code = {
-- 				["DF"] = "@function.outer",
-- 				["DF"] = "@class.outer",
-- 			},
-- 		},
-- 		keymaps = {
-- 			["iL"] = {
-- 				-- you can define your own textobjects directly here
-- 				go = "(function_definition) @function",
-- 			},
-- 			-- or you use the queries from supported languages with textobjects.scm
-- 			["af"] = "@function.outer",
-- 			["if"] = "@function.inner",
-- 			["aC"] = "@class.outer",
-- 			["iC"] = "@class.inner",
-- 			["ac"] = "@conditional.outer",
-- 			["ic"] = "@conditional.inner",
-- 			["ae"] = "@block.outer",
-- 			["ie"] = "@block.inner",
-- 			["al"] = "@loop.outer",
-- 			["il"] = "@loop.inner",
-- 			["is"] = "@statement.inner",
-- 			["as"] = "@statement.outer",
-- 			["ad"] = "@comment.outer",
-- 			["am"] = "@call.outer",
-- 			["im"] = "@call.inner",
-- 		},
-- 		move = {
-- 			enable = enable,
-- 			set_jumps = true, -- whether to set jumps in the jumplist
-- 			goto_next_start = {
-- 				["]m"] = "@function.outer",
-- 				["]]"] = "@class.outer",
-- 			},
-- 			goto_next_end = {
-- 				["]M"] = "@function.outer",
-- 				["]["] = "@class.outer",
-- 			},
-- 			goto_previous_start = {
-- 				["[m"] = "@function.outer",
-- 				["[["] = "@class.outer",
-- 			},
-- 			goto_previous_end = {
-- 				["[M"] = "@function.outer",
-- 				["[]"] = "@class.outer",
-- 			},
-- 		},
-- 		select = {
-- 			enable = enable,
-- 			keymaps = {
-- 				-- You can use the capture groups defined in textobjects.scm
-- 				["af"] = "@function.outer",
-- 				["if"] = "@function.inner",
-- 				["ac"] = "@class.outer",
-- 				["ic"] = "@class.inner",
-- 				-- Or you can define your own textobjects like this
-- 				["iF"] = {
-- 					python = "(function_definition) @function",
-- 					cpp = "(function_definition) @function",
-- 					c = "(function_definition) @function",
-- 					java = "(method_declaration) @function",
-- 					go = "(method_declaration) @function",
-- 				},
-- 			},
-- 		},
-- 		swap = {
-- 			enable = enable,
-- 			swap_next = {
-- 				["<leader>a"] = "@parameter.inner",
-- 			},
-- 			swap_previous = {
-- 				["<leader>A"] = "@parameter.inner",
-- 			},
-- 		},
-- 	},
-- })

require("treesitter-context").setup({
	enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
	max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
	trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
	min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
	patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
		-- For all filetypes
		-- Note that setting an entry here replaces all other patterns for this entry.
		-- By setting the 'default' entry below, you can control which nodes you want to
		-- appear in the context window.
		default = {
			"class",
			"function",
			"method",
			"for",
			"while",
			"if",
			"switch",
			"case",
		},
		-- Patterns for specific filetypes
		-- If a pattern is missing, *open a PR* so everyone can benefit.
		tex = {
			"chapter",
			"section",
			"subsection",
			"subsubsection",
		},
		rust = {
			"impl_item",
			"struct",
			"enum",
		},
		scala = {
			"object_definition",
		},
		vhdl = {
			"process_statement",
			"architecture_body",
			"entity_declaration",
		},
		markdown = {
			"section",
		},
		elixir = {
			"anonymous_function",
			"arguments",
			"block",
			"do_block",
			"list",
			"map",
			"tuple",
			"quoted_content",
		},
		json = {
			"pair",
		},
		yaml = {
			"block_mapping_pair",
		},
	},
	exact_patterns = {
		-- Example for a specific filetype with Lua patterns
		-- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
		-- exactly match "impl_item" only)
		-- rust = true,
	},

	-- [!] The options below are exposed but shouldn't require your attention,
	--     you can safely ignore them.

	zindex = 20, -- The Z-index of the context window
	mode = "topline", -- Line used to calculate context. Choices: 'cursor', 'topline'
	-- Separator between context and content. Should be a single character string, like '-'.
	-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
	separator = nil,
})
