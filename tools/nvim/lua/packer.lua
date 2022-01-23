-- For bootstrapping packer
local fn = vim.fn
loacl install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function(use)
  -- LSP server for neovim
  use 'neovim/nvim-lspconfig'

  -- Completion framework
  use {
    'hrsh7th/nvim-cmp',

    -- Completion sources for nvim-cmp
    -- LSP completion
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-vsnip',
    'quangnguyen30192/cmp-nvim-ultisnips',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-omni',
  }


  -- Search
  use {
    {
      'nvim-telescope/telescope.nvim',
      requires = {
        'nvim-lua/popup.nvim',
        'nvim-lua/plenary.nvim',
        'telescope-frecency.nvim',
        'telescope-fzf-native.nvim',
      },
      wants = {
        'popup.nvim',
        'plenary.nvim',
        'telescope-frecency.nvim',
        'telescope-fzf-native.nvim',
      },
      setup = [[require('config.telescope_setup')]],
      config = [[require('config.telescope')]],
      cmd = 'Telescope',
      module = 'telescope',
    },
    {
      'nvim-telescope/telescope-frecency.nvim',
      after = 'telescope.nvim',
      requires = 'tami5/sqlite.lua',
    },
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      run = 'make',
    },
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    requires = {
      'nvim-treesitter/nvim-treesitter-refactor',
      'RRethy/nvim-treesitter-textsubjects',
    },
    run = ':TSUpdate',
  }

  -- Git
  use {
    {
      'tpope/vim-fugitive',
      cmd = { 'Git', 'Gstatus', 'Gblame', 'Gpush', 'Gpull' },
      disable = true 
    },
    {
      'lewis6991/gitsigns.nvim',
      requires = { 'nvim-lua/plenary.nvim' },
      config = [[require('config.gitsigns')]],
    }
  }

  -- Rust
  -- To enable more of the features of rust-analyzer, such as inlay hints and more!
  use {
    'simrat39/rust-tools.nvim',
    requires = 'neovim/nvim-lspconfig',
    ft = {'rust'}
  }
  use {
    'saecki/crates.nvim',
    tag = 'v0.1.0',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
        require('crates').setup()
    end,
    ft = {'toml'}
  }

  -- Latex
  use {
    'lervag/vimtex',
    ft = {'tex'}
  }
  use {
    'KeitaNakamura/tex-conceal.vim',
    ft = {'tex'}
  }

  -- Markdown
  use {
    'iamcco/markdown-preview.nvim',
    run = function() vim.fn['mkdp#util#install']() end,
    ft = {'markdown'}
  }

  -- Automatically set up the configuration after cloning packer.nvim.
  if packer_bootstrap then
    require('packer').sync()
  end
end)

