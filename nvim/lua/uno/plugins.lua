local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
	fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
	execute("packadd packer.nvim")
end

local _group = vim.api.nvim_create_augroup("PackerCompile", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "plugins.lua",
	callback = function()
		vim.cmd("PackerCompile")
	end,
	group = _group,
})

return require("packer").startup(function()
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	-- Faster startup
	use({
		"lewis6991/impatient.nvim",
		config = require("impatient").setup,
	})
	-- use("nathom/filetype.nvim")

	-- Telescope
	use("folke/trouble.nvim")
	use("nvim-lua/popup.nvim")
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	use({
		"nvim-telescope/telescope.nvim",
		"nvim-telescope/telescope-file-browser.nvim",
		"danielpieper/telescope-tmuxinator.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
		"nvim-telescope/telescope-media-files.nvim",
		"nvim-telescope/telescope-dap.nvim",
		"nvim-telescope/telescope-fzy-native.nvim",
		"nvim-telescope/telescope-symbols.nvim",
		"cljoly/telescope-repo.nvim",
	})

	-- Theming
	use("dylanaraps/wal.vim")
	use("deviantfero/wpgtk.vim")
	use("ryanoasis/vim-devicons")
	use("rktjmp/lush.nvim")
	use("akinsho/nvim-bufferline.lua")
	use("norcalli/nvim-colorizer.lua")
	use("nvim-tree/nvim-web-devicons")
	use({ "folke/tokyonight.nvim" })
	use({ "ellisonleao/gruvbox.nvim" })

	-- User Interface
	use({ "sidebar-nvim/sidebar.nvim", rocks = { "luatz" } })
	use({ "beauwilliams/focus.nvim" })

	-- use({
	-- 	"anuvyklack/windows.nvim",
	-- 	requires = {
	-- 		"anuvyklack/middleclass",
	-- 		-- "anuvyklack/animation.nvim",
	-- 	},
	-- })

	-- Status line
	-- use {"joshuaMarple/galaxyline.nvim"}
	use({ "nvim-lualine/lualine.nvim" })
	use({ "rebelot/heirline.nvim" })

	-- Software Devlopment
	use({
		"kiyoon/jupynium.nvim",
		run = "pip3 install --user .",
		config = function()
			require("jupynium").setup({
				auto_start_server = {
					enable = false,
					file_pattern = { "*.ju.*" },
				},
			})
		end,
	})
	use("ekalinin/Dockerfile.vim")
	use("windwp/nvim-autopairs")
	use({
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup({ enable = true })
		end,
	})
	-- use("alvan/vim-closetag")
	use("ray-x/lsp_signature.nvim")

	-- Nvim Treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		requires = {
			"nvim-treesitter/nvim-treesitter-context",
			"nvim-treesitter/playground",
		},
	})
	use({ "JoosepAlviste/nvim-ts-context-commentstring" }) -- , after = "nvim-treesitter"

	-- Golang
	use({
		"ray-x/go.nvim",
		requires = {
			"mfussenegger/nvim-dap", -- Debug Adapter Protocol
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"ray-x/guihua.lua",
		},
	})

	-- Nvim LSP
	use({
		"neovim/nvim-lspconfig",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"jayp0521/mason-nvim-dap.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"jose-elias-alvarez/null-ls.nvim",
		"jayp0521/mason-null-ls.nvim",
		after = "go.nvim",
	})
	use("onsails/lspkind-nvim")
	-- use("tami5/lspsaga.nvim")
	use("stevearc/aerial.nvim")
	use({ "simrat39/symbols-outline.nvim" })
	use({
		"ray-x/navigator.lua",
		requires = {
			{ "ray-x/guihua.lua", run = "cd lua/fzy && make" },
			{ "neovim/nvim-lspconfig" },
		},
	})

	-- LSP Completion
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-cmdline")
	use("hrsh7th/nvim-cmp")
	use({ "tzachar/cmp-tabnine", run = "./install.sh", requires = "hrsh7th/nvim-cmp" })
	use({
		"David-Kunz/cmp-npm",
		-- after = "cmp-tabnine",
	})
	use({ "saadparwaiz1/cmp_luasnip" }) -- , after = "cmp-npm"
	use({ "L3MON4D3/LuaSnip", requires = { "rafamadriz/friendly-snippets" } }) -- , after = "cmp_luasnip"
	use("folke/neodev.nvim") -- For Neovim plugin dev

	-- Lsp Addons
	use({ "stevearc/dressing.nvim", requires = "MunifTanjim/nui.nvim" })
	use({ "folke/lsp-trouble.nvim" })
	use({ "jose-elias-alvarez/nvim-lsp-ts-utils", after = { "nvim-treesitter" } })

	-- Testing
	use({
		-- "nvim-neotest/neotest",
		"/home/tyler/Launchpad/temp/neotest-fork",
		requires = {
			-- "nvim-neotest/neotest-go",
			"/home/tyler/Launchpad/temp/neotest-go-fork",
			"nvim-lua/plenary.nvim",
			"nvim-neotest/neotest-python",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
		},
	})

	-- Misc
	use("github/copilot.vim")
	use("nvim-tree/nvim-tree.lua") -- File tree
	use("Pocco81/TrueZen.nvim") -- ZenMode
	use("rktjmp/fwatch.nvim") -- file watcher for themes
	use("sbdchd/neoformat") -- file formatting
	use("mhartington/formatter.nvim")
	use("akinsho/nvim-toggleterm.lua")
	use({ "AndrewRadev/splitjoin.vim" }) -- to expand / contract multiline
	use({ "numToStr/Comment.nvim" }) -- Comment stuff
	use({ "tpope/vim-repeat" })
	use({ "tpope/vim-speeddating" })
	use({ "tpope/vim-surround" })
	use({ "stevearc/stickybuf.nvim" })
	use({
		"folke/todo-comments.nvim",
		config = function()
			require("todo-comments").setup({})
		end,
	})
	use({ "antoinemadec/FixCursorHold.nvim" }) -- Needed while issue https://github.com/neovim/neovim/issues/12587 is still open
	use({ "rcarriga/nvim-notify" }) -- Notifications
	-- use("WhoIsSethDaniel/toggle-lsp-diagnostics.nvim")
	use({
		"vuki656/package-info.nvim",
		"MunifTanjim/nui.nvim",
		config = require("package-info").setup,
	})
	use({
		"ThePrimeagen/refactoring.nvim",
		requires = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-treesitter/nvim-treesitter" },
		},
	})
	use({ "uga-rosa/translate.nvim" })

	-- Text editing
	use({
		"iamcco/markdown-preview.nvim",
		run = "cd app && npm install",
		setup = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	})
	use({ "mattn/emmet-vim" })
	use({ "potatoesmaster/i3-vim-syntax" })

	-- use {"airblade/vim-rooter"}
	use({ "mvllow/modes.nvim" }) -- Highlights current line based on mode
	use({
		"zegervdv/nrpattern.nvim",
		config = function()
			-- Gives an error
			require("nrpattern").setup()
		end,
	})
	use({ "kevinhwang91/nvim-bqf", ft = "qf" }) -- Nicer quickfix list
	use({
		"ahmedkhalf/project.nvim",
		config = function()
			require("project_nvim").setup()
		end,
	})
	use("Pocco81/HighStr.nvim") -- Highlight lines

	-- Workspaces+sessions
	use({ "natecraddock/workspaces.nvim" })
	use({ "natecraddock/sessions.nvim" })

	-- Git stuff
	use("ThePrimeagen/git-worktree.nvim") -- look into how this works
	use("tpope/vim-fugitive") -- what is this again?
	use({ "sindrets/diffview.nvim", "nvim-lua/plenary.nvim" })
	use({ "lewis6991/gitsigns.nvim" })

	use("ThePrimeagen/harpoon") -- what is this again?
	use({
		"pwntester/octo.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"kyazdani42/nvim-web-devicons",
		},
		config = function()
			require("octo").setup()
		end,
	})

	use("famiu/nvim-reload")
	-- use("dlee/nvim-reload")

	-- Code Window
	use({ "gorbit99/codewindow.nvim" })

	-- use 'dstein64/vim-startuptime'
end)
