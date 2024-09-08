-- Ensure Packer is installed
-- local lazypath = vim.fn.stdpath("data") .. "/site/pack/packer/start/lazy.nvim"
-- if vim.fn.empty(vim.fn.glob(lazypath)) > 0 then
--   vim.fn.system({ "git", "clone", "https://github.com/folke/lazy.nvim", lazypath })
--   vim.cmd("packadd lazy.nvim")
-- end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Load and configure plugins
require("lazy").setup({
	-- Faster startup
	-- {"lewis6991/impatient.nvim", config = "require('impatient').setup()"},

	-- Telescope
	"folke/trouble.nvim",
	"nvim-lua/popup.nvim",
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-telescope/telescope-file-browser.nvim",
			"danielpieper/telescope-tmuxinator.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
			"nvim-telescope/telescope-media-files.nvim",
			"nvim-telescope/telescope-dap.nvim",
			"nvim-telescope/telescope-fzy-native.nvim",
			"nvim-telescope/telescope-symbols.nvim",
			"cljoly/telescope-repo.nvim",
		},
	},

	-- Theming
	"dylanaraps/wal.vim",
	"deviantfero/wpgtk.vim",
	"ryanoasis/vim-devicons",
	"rktjmp/lush.nvim",
	"akinsho/nvim-bufferline.lua",
	"norcalli/nvim-colorizer.lua",
	"nvim-tree/nvim-web-devicons",
	{ "folke/tokyonight.nvim" },
	{ "ellisonleao/gruvbox.nvim" },

	-- User Interface
	{ "sidebar-nvim/sidebar.nvim", rocks = "luatz" },
	{ "beauwilliams/focus.nvim" },

	-- Status line
	{ "nvim-lualine/lualine.nvim" },
	{ "rebelot/heirline.nvim" },

	-- Software Development
	{
		"kiyoon/jupynium.nvim",
		build = "pip3 install --user .",
		config = function()
			require("jupynium").setup({
				auto_start_server = {
					enable = false,
					file_pattern = { "*.ju.*" },
				},
			})
		end,
	},
	"ekalinin/Dockerfile.vim",
	"windwp/nvim-autopairs",
	{
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup({ enable = true })
		end,
	},
	"ray-x/lsp_signature.nvim",

	-- Nvim Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		-- build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-context",
			"nvim-treesitter/playground",
		},
	},
	{ "JoosepAlviste/nvim-ts-context-commentstring" },

	-- Golang
	{
		"ray-x/go.nvim",
		dependencies = {
			"mfussenegger/nvim-dap",
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"ray-x/guihua.lua",
		},
		ft = "go",
	},

	-- Workspaces+sessions
	{ "natecraddock/workspaces.nvim" },
	{ "natecraddock/sessions.nvim" },

	-- Nvim LSP
	{
		"neovim/nvim-lspconfig",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"jayp0521/mason-nvim-dap.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"jose-elias-alvarez/null-ls.nvim",
		"jayp0521/mason-null-ls.nvim",
	},
	"folke/trouble.nvim",
	{ "stevearc/dressing.nvim", dependencies = { "MunifTanjim/nui.nvim" } },
	"onsails/lspkind-nvim",
	"stevearc/aerial.nvim",
	{ "simrat39/symbols-outline.nvim" },
	{
		"ray-x/navigator.lua",
		dependencies = {
			{ "ray-x/guihua.lua", build = "cd lua/fzy && make" },
			{ "neovim/nvim-lspconfig" },
		},
	},

	-- LSP Completion
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-cmdline",
	"hrsh7th/nvim-cmp",
	{ "tzachar/cmp-tabnine", build = "./install.sh", dependencies = "hrsh7th/nvim-cmp" },
	{ "David-Kunz/cmp-npm" },
	{ "saadparwaiz1/cmp_luasnip" },
	{ "L3MON4D3/LuaSnip", dependencies = { "rafamadriz/friendly-snippets" } },

	-- Misc
	{ "mvllow/modes.nvim" },
	{ "kevinhwang91/nvim-bqf", ft = "qf" },
	"github/copilot.vim",
	"nvim-tree/nvim-tree.lua",
	"Pocco81/TrueZen.nvim",
	"rktjmp/fwatch.nvim",
	"sbdchd/neoformat",
	"mhartington/formatter.nvim",
	"akinsho/nvim-toggleterm.lua",
	{ "AndrewRadev/splitjoin.vim" },
	{ "numToStr/Comment.nvim" },
	{ "tpope/vim-repeat" },
	{ "tpope/vim-speeddating" },
	{ "tpope/vim-surround" },
	-- { "stevearc/stickybuf.nvim" },
	{
		"folke/todo-comments.nvim",
		config = function()
			require("todo-comments").setup({})
		end,
	},
	{ "antoinemadec/FixCursorHold.nvim" },
	{ "rcarriga/nvim-notify" },

	-- Testing
	{
		"nvim-neotest/neotest",
		-- dir = "/home/tyler/Launchpad/temp/neotest-fork",
		dependencies = {
			"nvim-neotest/neotest-go",
			-- "/home/tyler/Launchpad/temp/neotest-go-fork",
			"nvim-lua/plenary.nvim",
			"nvim-neotest/neotest-python",
			"nvim-neotest/nvim-nio",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
		},
	},

	-- Git
	"ThePrimeagen/git-worktree.nvim",
	"tpope/vim-fugitive",
	{
		"FabijanZulj/blame.nvim",
		config = function()
			require("blame").setup()
		end,
	},
	{ "sindrets/diffview.nvim", dependencies = "nvim-lua/plenary.nvim" },
	{ "lewis6991/gitsigns.nvim" },
	{
		"akinsho/git-conflict.nvim",
		config = function()
			require("git-conflict").setup()
		end,
	},

	{ "kevinhwang91/nvim-ufo", dependencies = "kevinhwang91/promise-async" },

	-- More Plugins
	{
		"hat0uma/csvview.nvim",
		config = function()
			require("csvview").setup()
		end,
	},
	"ThePrimeagen/harpoon",
	{
		"pwntester/octo.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("octo").setup({
				suppress_missing_scope = {
					projects_v2 = true,
				},
			})
		end,
	},
	{
		"luukvbaal/statuscol.nvim",
		config = function()
			local builtin = require("statuscol.builtin")
			local c = require("statuscol.ffidef").C
			require("statuscol").setup({
				relculright = true,
				segments = {
					{
						sign = {
							namespace = { "gitsigns" },
							name = { ".*" },
							maxwidth = 1,
							colwidth = 1,
							auto = false,
						},
						click = "v:lua.ScSa",
						-- condition = {
						-- 	function(args)
						-- 		-- only show if signcolumn is enabled
						-- 		return args.sclnu
						-- 	end,
						-- },
					},
					{
						-- TODO: Change this after v0.10. See the following discussion:
						-- https://github.com/luukvbaal/statuscol.nvim/issues/103#issuecomment-1937791243
						sign = {
							name = { "Diagnostic" },
							maxwidth = 2,
							colwidth = 1,
							auto = false,
						},
						click = "v:lua.ScSa",
						condition = {
							function(args)
								-- only show if signcolumn is enabled
								return args.sclnu
							end,
						},
					},
					{ text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
					{
						text = {
							-- Amazing foldcolumn
							-- https://github.com/kevinhwang91/nvim-ufo/issues/4
							function(args)
								local foldinfo = c.fold_info(args.wp, args.lnum)
								local foldinfo_next = c.fold_info(args.wp, args.lnum + 1)
								local level = foldinfo.level
								local foldstr = " "
								local hl = "%#FoldCol" .. level .. "#"
								if level == 0 then
									hl = "%#Normal#"
									foldstr = " "
									return hl .. foldstr .. "%#Normal# "
								end
								if level > 8 then
									hl = "%#FoldCol8#"
								end
								if foldinfo.lines ~= 0 then
									foldstr = "▹"
								elseif args.lnum == foldinfo.start then
									foldstr = "◠"
								elseif
									foldinfo.level > foldinfo_next.level
									or (foldinfo_next.start == args.lnum + 1 and foldinfo_next.level == foldinfo.level)
								then
									foldstr = "◡"
								end
								return hl .. foldstr .. "%#Normal# "
							end,
						},
						click = "v:lua.ScFa",
						condition = {
							function(args)
								return args.fold.width ~= 0
							end,
						},
					},
				},
			})
		end,
	},
	"famiu/nvim-reload",
	{ "gorbit99/codewindow.nvim" },
}, {
	performance = { reset_packpath = false, rtp = { reset = false } },
})
