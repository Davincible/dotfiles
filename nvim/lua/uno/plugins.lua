local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
	fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
	execute("packadd packer.nvim")
end

return require("packer").startup(function()
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	-- Faster startup
	use({
		"lewis6991/impatient.nvim",
		config = require("impatient").setup,
	})
	use("nathom/filetype.nvim")

	-- Telescope
	use("folke/trouble.nvim")
	use("nvim-lua/popup.nvim")
	use("nvim-lua/plenary.nvim")
	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			"nvim-telescope/telescope-file-browser.nvim",
			"danielpieper/telescope-tmuxinator.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
			"nvim-telescope/telescope-media-files.nvim",
			"nvim-telescope/telescope-project.nvim",
			"nvim-telescope/telescope-dap.nvim",
			"nvim-telescope/telescope-fzy-native.nvim",
			"nvim-telescope/telescope-symbols.nvim",
		},
	})

	-- Theming
	use("dylanaraps/wal.vim")
	use("deviantfero/wpgtk.vim")
	use("ryanoasis/vim-devicons")
	use("rktjmp/lush.nvim")
	use("akinsho/nvim-bufferline.lua")
	use("norcalli/nvim-colorizer.lua")

	-- Status line
	-- use {"joshuaMarple/galaxyline.nvim"}
	use({ "nvim-lualine/lualine.nvim" })

	-- Software Devlopment
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
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	use("nvim-treesitter/playground")
	use("kyazdani42/nvim-web-devicons")

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
	use({ "neovim/nvim-lspconfig", "williamboman/nvim-lsp-installer", after = "go.nvim" })
	use("onsails/lspkind-nvim")
	use("tami5/lspsaga.nvim")

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
		requires = "nvim-lua/plenary.nvim",
	})
	use({ "saadparwaiz1/cmp_luasnip" }) -- , after = "cmp-npm"
	use({ "L3MON4D3/LuaSnip", requires = { "rafamadriz/friendly-snippets" } }) -- , after = "cmp_luasnip"

	-- Lsp Addons
	use({ "stevearc/dressing.nvim", requires = "MunifTanjim/nui.nvim" })
	use({ "folke/lsp-trouble.nvim" })
	use({ "jose-elias-alvarez/nvim-lsp-ts-utils", after = { "nvim-treesitter" } })

	-- Misc
	use("kyazdani42/nvim-tree.lua")
	use("Pocco81/TrueZen.nvim")
	use("rktjmp/fwatch.nvim") -- file watcher for themes
	use("sbdchd/neoformat") -- file formatting
	use("akinsho/nvim-toggleterm.lua")
	use({ "AndrewRadev/splitjoin.vim" }) -- to expand / contract multiline
	use({ "numToStr/Comment.nvim" }) -- Comment stuff
	use({ "JoosepAlviste/nvim-ts-context-commentstring" }) -- , after = "nvim-treesitter"
	use({ "tpope/vim-repeat" })
	use({ "tpope/vim-speeddating" })
	use({ "tpope/vim-surround" })
	use({ "folke/todo-comments.nvim", config = "require('todo-comments')" })
	use({ "antoinemadec/FixCursorHold.nvim" }) -- Needed while issue https://github.com/neovim/neovim/issues/12587 is still open
	use({ "rcarriga/nvim-notify" })
	use({
		"vuki656/package-info.nvim",
		requires = "MunifTanjim/nui.nvim",
		config = "require('package-info').setup()",
	})
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
	use({ "zegervdv/nrpattern.nvim", config = "require('nrpattern').setup()" })
	use({ "kevinhwang91/nvim-bqf", ft = "qf" }) -- Nicer quickfix list
	use({
		"ahmedkhalf/project.nvim",
		config = function()
			require("project_nvim").setup()
		end,
	})

	-- Git stuff
	use("ThePrimeagen/git-worktree.nvim") -- look into how this works
	use("tpope/vim-fugitive") -- what is this again?
	use({ "sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim" })

	use("ThePrimeagen/harpoon") -- what is this again?
	use("famiu/nvim-reload")
	-- use("dlee/nvim-reload")

	use({ "lewis6991/gitsigns.nvim" })

	-- use 'dstein64/vim-startuptime'
end)
