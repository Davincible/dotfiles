
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Telescope, fzf replacement fuzzy scanner
  use "folke/trouble.nvim"
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'
  use 'nvim-telescope/telescope-fzy-native.nvim'
  use 'nvim-telescope/telescope-project.nvim'

  -- Theming
  use 'dylanaraps/wal.vim'
  use 'deviantfero/wpgtk.vim'
  use 'chrisbra/Colorizer'
  use 'ryanoasis/vim-devicons'
  use 'rktjmp/lush.nvim'
  use "akinsho/nvim-bufferline.lua"
  use 'norcalli/nvim-colorizer.lua'
  use 'glepnir/galaxyline.nvim'

  -- Software Devlopment
  -- TODO: Currntly doesn't support lsp and treesitter, check back later
  -- use {'fatih/vim-go', run = ':GoUpdateBinaries'}
  use 'ekalinin/Dockerfile.vim'
  use 'windwp/nvim-autopairs'
  use 'alvan/vim-closetag'
  use 'ray-x/lsp_signature.nvim'

  -- Nvim LSP
  use 'neovim/nvim-lspconfig'
  use 'kabouzeid/nvim-lspinstall'
  use 'hrsh7th/nvim-compe'
  use 'onsails/lspkind-nvim'
	use 'glepnir/lspsaga.nvim'

  -- Nvim Treesitter
  use {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"}
  use 'nvim-treesitter/playground'
  use 'kyazdani42/nvim-web-devicons'

  -- Misc
  use 'kyazdani42/nvim-tree.lua'
  use 'Pocco81/TrueZen.nvim'
  use 'rktjmp/fwatch.nvim'
  use 'sbdchd/neoformat'
  use 'akinsho/nvim-toggleterm.lua'

  -- Golang
  use 'ray-x/go.nvim'

  -- Git stuff
  use 'ThePrimeagen/git-worktree.nvim'
  use 'tpope/vim-fugitive'

  use 'ThePrimeagen/harpoon'
  use 'famiu/nvim-reload'

  use 'lewis6991/gitsigns.nvim'
end)

