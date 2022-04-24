-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/aikow/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/aikow/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/aikow/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/aikow/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/aikow/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["Comment.nvim"] = {
    config = { "\27LJ\2\n\2\0\0\4\0\r\0\0176\0\0\0'\2\1\0B\0\2\0027\0\2\0006\0\2\0009\0\3\0005\2\4\0005\3\5\0=\3\6\0025\3\a\0=\3\b\0025\3\t\0=\3\n\0025\3\v\0=\3\f\2B\0\2\1K\0\1\0\rmappings\1\0\3\nbasic\2\nextra\2\rextended\1\nextra\1\0\3\beol\bgcA\nabove\bgcO\nbelow\bgco\ropleader\1\0\2\tline\agc\nblock\agb\ftoggler\1\0\2\tline\bgcc\nblock\bgbb\1\0\2\fpadding\2\vsticky\2\nsetup\fcomment\fComment\frequire\0" },
    loaded = true,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/start/Comment.nvim",
    url = "https://github.com/numToStr/Comment.nvim"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-cmdline"] = {
    loaded = true,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/start/cmp-cmdline",
    url = "https://github.com/hrsh7th/cmp-cmdline"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-nvim-lua"] = {
    loaded = true,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/start/cmp-nvim-lua",
    url = "https://github.com/hrsh7th/cmp-nvim-lua"
  },
  ["cmp-nvim-ultisnips"] = {
    loaded = true,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/start/cmp-nvim-ultisnips",
    url = "https://github.com/quangnguyen30192/cmp-nvim-ultisnips"
  },
  ["cmp-omni"] = {
    loaded = true,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/start/cmp-omni",
    url = "https://github.com/hrsh7th/cmp-omni"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/start/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  ["crates.nvim"] = {
    after_files = { "/home/aikow/.local/share/nvim/site/pack/packer/opt/crates.nvim/after/plugin/cmp_crates.lua" },
    config = { "\27LJ\2\n4\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\vcrates\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/opt/crates.nvim",
    url = "https://github.com/saecki/crates.nvim"
  },
  ["dressing.nvim"] = {
    loaded = true,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/start/dressing.nvim",
    url = "https://github.com/stevearc/dressing.nvim"
  },
  ["fzf.vim"] = {
    config = { "\27LJ\2\nf\0\0\4\0\6\0\t6\0\0\0009\0\1\0006\1\0\0009\1\3\0019\1\4\1'\3\5\0B\1\2\2=\1\2\0K\0\1\0\31~/.local/share/fzf-history\vexpand\afn\20fzf_history_dir\6g\bvim\0" },
    loaded = true,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/start/fzf.vim",
    url = "https://github.com/junegunn/fzf.vim"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\n:\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\rgitsigns\frequire\0" },
    loaded = true,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/start/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  ["gruvbox-material"] = {
    loaded = true,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/start/gruvbox-material",
    url = "https://github.com/sainnhe/gruvbox-material"
  },
  ["lspkind.nvim"] = {
    loaded = true,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/start/lspkind.nvim",
    url = "https://github.com/onsails/lspkind.nvim"
  },
  ["lualine.nvim"] = {
    config = { "\27LJ\2\nî\5\0\0\a\0%\1B6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\t\0005\3\3\0005\4\4\0=\4\5\0035\4\6\0=\4\a\0034\4\0\0=\4\b\3=\3\n\0025\3\f\0005\4\v\0=\4\r\0035\4\14\0=\4\15\0035\4\16\0=\4\17\0035\4\18\0=\4\19\0035\4\20\0=\4\21\0035\4\22\0=\4\23\3=\3\24\0025\3\25\0004\4\0\0=\4\r\0034\4\0\0=\4\15\0035\4\26\0=\4\17\0035\4\27\0=\4\19\0034\4\0\0=\4\21\0034\4\0\0=\4\23\3=\3\28\0025\3\"\0004\4\3\0005\5\29\0006\6\30\0009\6\31\0069\6 \6\25\6\0\6=\6!\5>\5\1\4=\4\r\0034\4\0\0=\4\15\0034\4\0\0=\4\17\0034\4\0\0=\4\19\0034\4\0\0=\4\21\0034\4\0\0=\4\23\3=\3#\0024\3\0\0=\3$\2B\0\2\1K\0\1\0\15extensions\ftabline\1\0\0\15max_length\fcolumns\6o\bvim\1\2\1\0\ttabs\tmode\3\2\22inactive_sections\1\2\0\0\rlocation\1\2\0\0\rfilename\1\0\0\rsections\14lualine_z\1\2\0\0\rlocation\14lualine_y\1\2\0\0\rprogress\14lualine_x\1\4\0\0\15fileformat\rfiletype\rencoding\14lualine_c\1\2\0\0\rfilename\14lualine_b\1\4\0\0\vbranch\tdiff\16diagnostics\14lualine_a\1\0\0\1\2\0\0\tmode\foptions\1\0\0\23disabled_filetypes\23section_separators\1\0\2\tleft\bî‚°\nright\bî‚²\25component_separators\1\0\2\tleft\bî‚±\nright\bî‚³\1\0\3\25always_divide_middle\2\ntheme\tauto\18icons_enabled\2\nsetup\flualine\frequire\6\0" },
    loaded = true,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/start/lualine.nvim",
    url = "https://github.com/nvim-lualine/lualine.nvim"
  },
  luasnip = {
    loaded = true,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/start/luasnip",
    url = "https://github.com/L3MON4D3/luasnip"
  },
  ["markdown-preview.nvim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/opt/markdown-preview.nvim",
    url = "https://github.com/iamcco/markdown-preview.nvim"
  },
  ["nord-vim"] = {
    loaded = true,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/start/nord-vim",
    url = "https://github.com/arcticicestudio/nord-vim"
  },
  ["nvim-cmp"] = {
    loaded = true,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\nå\3\0\0\6\0\17\0\0216\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0005\4\5\0=\4\6\3=\3\a\0025\3\b\0=\3\t\0025\3\v\0005\4\n\0=\4\f\0035\4\r\0005\5\14\0=\5\6\4=\4\15\3=\3\16\2B\0\2\1K\0\1\0\rrefactor\17smart_rename\1\0\1\17smart_rename\15<leader>rr\1\0\1\venable\2\26highlight_definitions\1\0\0\1\0\2\25clear_on_custor_move\2\venable\2\14highlight\1\0\2&additional_vim_regex_highlighting\nlatex\venable\2\26incremental_selection\fkeymaps\1\0\4\21node_decremental\n<C-j>\19init_selection\14<leader>v\21node_incremental\n<C-k>\22scope_incremental\n<C-l>\1\0\1\venable\2\1\0\2\17sync_install\1\21ensure_installed\ball\nsetup\28nvim-treesitter.configs\frequire\0" },
    loaded = true,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-treesitter-refactor"] = {
    loaded = true,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/start/nvim-treesitter-refactor",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-refactor"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["onedark.vim"] = {
    loaded = true,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/start/onedark.vim",
    url = "https://github.com/joshdick/onedark.vim"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["rust-tools.nvim"] = {
    loaded = true,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/start/rust-tools.nvim",
    url = "https://github.com/simrat39/rust-tools.nvim"
  },
  ["spellsitter.nvim"] = {
    config = { "\27LJ\2\nH\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\venable\2\nsetup\16spellsitter\frequire\0" },
    loaded = true,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/start/spellsitter.nvim",
    url = "https://github.com/lewis6991/spellsitter.nvim"
  },
  tabular = {
    loaded = true,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/start/tabular",
    url = "https://github.com/godlygeek/tabular"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzf-native.nvim"
  },
  ["telescope-ultisnips.nvim"] = {
    loaded = true,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/start/telescope-ultisnips.nvim",
    url = "https://github.com/fhill2/telescope-ultisnips.nvim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\n‘\14\0\0\v\0Y\0¥\0016\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0026\2\0\0'\4\3\0B\2\2\0029\3\4\0025\5K\0005\6G\0005\a8\0005\b\6\0009\t\5\0=\t\a\b9\t\b\0=\t\t\b9\t\n\0=\t\v\b9\t\f\0=\t\r\b9\t\14\0=\t\15\b9\t\16\0=\t\17\b9\t\18\0=\t\19\b9\t\20\0=\t\21\b9\t\22\0=\t\23\b9\t\24\0=\t\25\b9\t\26\0=\t\27\b9\t\28\0=\t\29\b9\t\28\0009\n\30\0 \t\n\t=\t\31\b9\t\28\0009\n \0 \t\n\t=\t!\b9\t\"\0=\t#\b5\t$\0=\t%\b9\t&\0=\t'\b9\t(\0=\t)\b9\t*\1=\t+\b9\t,\0=\t-\b9\t.\0009\n/\0 \t\n\t=\t0\b9\t1\0009\n/\0 \t\n\t=\t2\b9\t3\0009\n4\0 \t\n\t=\t5\b9\t6\0009\n4\0 \t\n\t=\t7\b=\b9\a5\b:\0009\t\5\0=\t\a\b9\t\b\0=\t\t\b9\t\5\0=\t;\b9\t\b\0=\t<\b9\t=\0=\t>\b9\t?\0=\t@\b9\tA\0=\tB\b9\t=\0=\tC\b9\tA\0=\tD\b9\t\n\0=\tE\b9\t\f\0=\t\r\b9\t\14\0=\t\15\b9\t\16\0=\t\17\b9\t\18\0=\t\19\b9\t\28\0=\t\29\b9\t\28\0009\n\30\0 \t\n\t=\t\31\b9\t\28\0009\n \0 \t\n\t=\t!\b9\t\20\0=\t\21\b9\t\22\0=\t\23\b9\t\24\0=\t\25\b9\t\26\0=\t\27\b9\t*\1=\t+\b9\t,\0=\t-\b9\t.\0009\n/\0 \t\n\t=\t0\b9\t1\0009\n/\0 \t\n\t=\t2\b9\t3\0009\n4\0 \t\n\t=\t5\b9\t6\0009\n4\0 \t\n\t=\t7\b=\bF\a=\aH\0065\aI\0=\aJ\6=\6L\0055\6P\0005\aN\0005\bM\0=\bO\a=\aQ\6=\6R\0055\6T\0005\aS\0=\aU\6=\6V\5B\3\2\0019\3W\2'\5U\0B\3\2\0019\3W\2'\5X\0B\3\2\1K\0\1\0\14ultisnips\19load_extension\15extensions\bfzf\1\0\0\1\0\4\28override_generic_sorter\2\nfuzzy\2\14case_mode\15smart_case\25override_file_sorter\2\fpickers\15find_files\1\0\0\17find_command\1\0\0\1\t\0\0\afd\14--exclude\t.git\r--hidden\20--no-ignore-vcs\v--type\6f\23--strip-cwd-prefix\rdefaults\1\0\0\22vimgrep_arguments\1\t\0\0\arg\18--color=never\17--no-heading\20--with-filename\18--line-number\r--column\17--smart-case\v--trim\rmappings\1\0\0\6n\n<esc>\6G\agg\6L\19move_to_bottom\6M\19move_to_middle\6H\16move_to_top\6k\6j\1\0\0\6i\1\0\0\v<C-l>l\25smart_add_to_loclist\15<C-l><C-l>\17open_loclist\26smart_send_to_loclist\v<C-q>q\24smart_add_to_qflist\15<C-q><C-q>\16open_qflist\25smart_send_to_qflist\n<C-h>\14which_key\n<C-_>\19toggle_preview\n<C-p>\23cycle_history_prev\n<C-n>\23cycle_history_next\n<C-w>\1\2\1\0\f<c-s-w>\ttype\fcommand\n<C-l>\17complete_tag\f<S-Tab>\26move_selection_better\n<Tab>\25move_selection_worse\14<C-space>\21toggle_selection\n<C-f>\27results_scrolling_down\n<C-b>\25results_scrolling_up\n<C-d>\27preview_scrolling_down\n<C-u>\25preview_scrolling_up\n<C-t>\15select_tab\n<C-v>\20select_vertical\n<C-x>\22select_horizontal\t<CR>\19select_default\n<C-c>\nclose\n<C-k>\28move_selection_previous\n<C-j>\1\0\0\24move_selection_next\nsetup\14telescope\29telescope.actions.layout\22telescope.actions\frequire\0" },
    loaded = true,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["tex-conceal.vim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/opt/tex-conceal.vim",
    url = "https://github.com/KeitaNakamura/tex-conceal.vim"
  },
  ultisnips = {
    config = { "\27LJ\2\nŸ\1\0\0\2\0\a\0\r6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0'\1\3\0=\1\4\0006\0\0\0009\0\1\0'\1\6\0=\1\5\0K\0\1\0\f<s-tab>!UltiSnipsJumpBackwardTrigger UltiSnipsJumpForwardTrigger\n<tab>\27UltiSnipsExpandTrigger\6g\bvim\0" },
    loaded = true,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/start/ultisnips",
    url = "https://github.com/sirver/ultisnips"
  },
  ["vim-fish"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/opt/vim-fish",
    url = "https://github.com/dag/vim-fish"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/start/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/start/vim-repeat",
    url = "https://github.com/tpope/vim-repeat"
  },
  ["vim-rooter"] = {
    loaded = true,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/start/vim-rooter",
    url = "https://github.com/airblade/vim-rooter"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/start/vim-surround",
    url = "https://github.com/tpope/vim-surround"
  },
  ["vim-tmux-navigator"] = {
    loaded = true,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/start/vim-tmux-navigator",
    url = "https://github.com/christoomey/vim-tmux-navigator"
  },
  ["vim-vinegar"] = {
    loaded = true,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/start/vim-vinegar",
    url = "https://github.com/tpope/vim-vinegar"
  },
  vimtex = {
    config = { "\27LJ\2\nÃ\1\0\0\5\0\t\0\0236\0\0\0009\0\1\0'\1\2\0006\2\0\0009\2\3\0029\2\4\2'\4\5\0B\2\2\2&\1\2\1'\2\6\0<\2\1\0006\0\0\0009\0\1\0'\1\2\0006\2\0\0009\2\3\0029\2\4\2'\4\a\0B\2\2\2&\1\2\1'\2\b\0<\2\1\0K\0\1\0\24\\\\\\1command: \\1{\\r}\6c2\\\\begin{\\1environment: \\1}\\n\\t\\r\\n\\\\end{\\1\\1}\6e\fchar2nr\afn\rsurround\6b\bvimÊ\3\1\0\5\0\19\0 6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0'\1\5\0=\1\4\0006\0\0\0009\0\1\0)\1\0\0=\1\6\0006\0\0\0009\0\1\0'\1\b\0=\1\a\0006\0\0\0009\0\1\0005\1\n\0004\2\0\0=\2\v\0015\2\f\0=\2\r\1=\1\t\0006\0\0\0009\0\14\0009\0\15\0'\2\16\0003\3\17\0005\4\18\0B\0\4\1K\0\1\0\1\0\1\nnargs\3\0\0\18LatexSurround\29nvim_create_user_command\bapi\foptions\1\5\0\0\r-verbose\21-file-line-error\15-synctex=1\29-interaction=nonstopmode\nhooks\1\0\4\rcallback\3\1\14build_dir\nbuild\15executable\flatexmk\15continuous\3\1\28vimtex_compiler_latexmk\flatexmk\27vimtex_compiler_method\25vimtex_quickfix_mode\fzathura\23vimtex_view_method\nlatex\15tex_flavor\6g\bvim\0" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/aikow/.local/share/nvim/site/pack/packer/opt/vimtex",
    url = "https://github.com/lervag/vimtex"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: ultisnips
time([[Config for ultisnips]], true)
try_loadstring("\27LJ\2\nŸ\1\0\0\2\0\a\0\r6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0'\1\3\0=\1\4\0006\0\0\0009\0\1\0'\1\6\0=\1\5\0K\0\1\0\f<s-tab>!UltiSnipsJumpBackwardTrigger UltiSnipsJumpForwardTrigger\n<tab>\27UltiSnipsExpandTrigger\6g\bvim\0", "config", "ultisnips")
time([[Config for ultisnips]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\n‘\14\0\0\v\0Y\0¥\0016\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0026\2\0\0'\4\3\0B\2\2\0029\3\4\0025\5K\0005\6G\0005\a8\0005\b\6\0009\t\5\0=\t\a\b9\t\b\0=\t\t\b9\t\n\0=\t\v\b9\t\f\0=\t\r\b9\t\14\0=\t\15\b9\t\16\0=\t\17\b9\t\18\0=\t\19\b9\t\20\0=\t\21\b9\t\22\0=\t\23\b9\t\24\0=\t\25\b9\t\26\0=\t\27\b9\t\28\0=\t\29\b9\t\28\0009\n\30\0 \t\n\t=\t\31\b9\t\28\0009\n \0 \t\n\t=\t!\b9\t\"\0=\t#\b5\t$\0=\t%\b9\t&\0=\t'\b9\t(\0=\t)\b9\t*\1=\t+\b9\t,\0=\t-\b9\t.\0009\n/\0 \t\n\t=\t0\b9\t1\0009\n/\0 \t\n\t=\t2\b9\t3\0009\n4\0 \t\n\t=\t5\b9\t6\0009\n4\0 \t\n\t=\t7\b=\b9\a5\b:\0009\t\5\0=\t\a\b9\t\b\0=\t\t\b9\t\5\0=\t;\b9\t\b\0=\t<\b9\t=\0=\t>\b9\t?\0=\t@\b9\tA\0=\tB\b9\t=\0=\tC\b9\tA\0=\tD\b9\t\n\0=\tE\b9\t\f\0=\t\r\b9\t\14\0=\t\15\b9\t\16\0=\t\17\b9\t\18\0=\t\19\b9\t\28\0=\t\29\b9\t\28\0009\n\30\0 \t\n\t=\t\31\b9\t\28\0009\n \0 \t\n\t=\t!\b9\t\20\0=\t\21\b9\t\22\0=\t\23\b9\t\24\0=\t\25\b9\t\26\0=\t\27\b9\t*\1=\t+\b9\t,\0=\t-\b9\t.\0009\n/\0 \t\n\t=\t0\b9\t1\0009\n/\0 \t\n\t=\t2\b9\t3\0009\n4\0 \t\n\t=\t5\b9\t6\0009\n4\0 \t\n\t=\t7\b=\bF\a=\aH\0065\aI\0=\aJ\6=\6L\0055\6P\0005\aN\0005\bM\0=\bO\a=\aQ\6=\6R\0055\6T\0005\aS\0=\aU\6=\6V\5B\3\2\0019\3W\2'\5U\0B\3\2\0019\3W\2'\5X\0B\3\2\1K\0\1\0\14ultisnips\19load_extension\15extensions\bfzf\1\0\0\1\0\4\28override_generic_sorter\2\nfuzzy\2\14case_mode\15smart_case\25override_file_sorter\2\fpickers\15find_files\1\0\0\17find_command\1\0\0\1\t\0\0\afd\14--exclude\t.git\r--hidden\20--no-ignore-vcs\v--type\6f\23--strip-cwd-prefix\rdefaults\1\0\0\22vimgrep_arguments\1\t\0\0\arg\18--color=never\17--no-heading\20--with-filename\18--line-number\r--column\17--smart-case\v--trim\rmappings\1\0\0\6n\n<esc>\6G\agg\6L\19move_to_bottom\6M\19move_to_middle\6H\16move_to_top\6k\6j\1\0\0\6i\1\0\0\v<C-l>l\25smart_add_to_loclist\15<C-l><C-l>\17open_loclist\26smart_send_to_loclist\v<C-q>q\24smart_add_to_qflist\15<C-q><C-q>\16open_qflist\25smart_send_to_qflist\n<C-h>\14which_key\n<C-_>\19toggle_preview\n<C-p>\23cycle_history_prev\n<C-n>\23cycle_history_next\n<C-w>\1\2\1\0\f<c-s-w>\ttype\fcommand\n<C-l>\17complete_tag\f<S-Tab>\26move_selection_better\n<Tab>\25move_selection_worse\14<C-space>\21toggle_selection\n<C-f>\27results_scrolling_down\n<C-b>\25results_scrolling_up\n<C-d>\27preview_scrolling_down\n<C-u>\25preview_scrolling_up\n<C-t>\15select_tab\n<C-v>\20select_vertical\n<C-x>\22select_horizontal\t<CR>\19select_default\n<C-c>\nclose\n<C-k>\28move_selection_previous\n<C-j>\1\0\0\24move_selection_next\nsetup\14telescope\29telescope.actions.layout\22telescope.actions\frequire\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: fzf.vim
time([[Config for fzf.vim]], true)
try_loadstring("\27LJ\2\nf\0\0\4\0\6\0\t6\0\0\0009\0\1\0006\1\0\0009\1\3\0019\1\4\1'\3\5\0B\1\2\2=\1\2\0K\0\1\0\31~/.local/share/fzf-history\vexpand\afn\20fzf_history_dir\6g\bvim\0", "config", "fzf.vim")
time([[Config for fzf.vim]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
try_loadstring("\27LJ\2\n:\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\rgitsigns\frequire\0", "config", "gitsigns.nvim")
time([[Config for gitsigns.nvim]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\nå\3\0\0\6\0\17\0\0216\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0005\4\5\0=\4\6\3=\3\a\0025\3\b\0=\3\t\0025\3\v\0005\4\n\0=\4\f\0035\4\r\0005\5\14\0=\5\6\4=\4\15\3=\3\16\2B\0\2\1K\0\1\0\rrefactor\17smart_rename\1\0\1\17smart_rename\15<leader>rr\1\0\1\venable\2\26highlight_definitions\1\0\0\1\0\2\25clear_on_custor_move\2\venable\2\14highlight\1\0\2&additional_vim_regex_highlighting\nlatex\venable\2\26incremental_selection\fkeymaps\1\0\4\21node_decremental\n<C-j>\19init_selection\14<leader>v\21node_incremental\n<C-k>\22scope_incremental\n<C-l>\1\0\1\venable\2\1\0\2\17sync_install\1\21ensure_installed\ball\nsetup\28nvim-treesitter.configs\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: spellsitter.nvim
time([[Config for spellsitter.nvim]], true)
try_loadstring("\27LJ\2\nH\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\venable\2\nsetup\16spellsitter\frequire\0", "config", "spellsitter.nvim")
time([[Config for spellsitter.nvim]], false)
-- Config for: Comment.nvim
time([[Config for Comment.nvim]], true)
try_loadstring("\27LJ\2\n\2\0\0\4\0\r\0\0176\0\0\0'\2\1\0B\0\2\0027\0\2\0006\0\2\0009\0\3\0005\2\4\0005\3\5\0=\3\6\0025\3\a\0=\3\b\0025\3\t\0=\3\n\0025\3\v\0=\3\f\2B\0\2\1K\0\1\0\rmappings\1\0\3\nbasic\2\nextra\2\rextended\1\nextra\1\0\3\beol\bgcA\nabove\bgcO\nbelow\bgco\ropleader\1\0\2\tline\agc\nblock\agb\ftoggler\1\0\2\tline\bgcc\nblock\bgbb\1\0\2\fpadding\2\vsticky\2\nsetup\fcomment\fComment\frequire\0", "config", "Comment.nvim")
time([[Config for Comment.nvim]], false)
-- Config for: lualine.nvim
time([[Config for lualine.nvim]], true)
try_loadstring("\27LJ\2\nî\5\0\0\a\0%\1B6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\t\0005\3\3\0005\4\4\0=\4\5\0035\4\6\0=\4\a\0034\4\0\0=\4\b\3=\3\n\0025\3\f\0005\4\v\0=\4\r\0035\4\14\0=\4\15\0035\4\16\0=\4\17\0035\4\18\0=\4\19\0035\4\20\0=\4\21\0035\4\22\0=\4\23\3=\3\24\0025\3\25\0004\4\0\0=\4\r\0034\4\0\0=\4\15\0035\4\26\0=\4\17\0035\4\27\0=\4\19\0034\4\0\0=\4\21\0034\4\0\0=\4\23\3=\3\28\0025\3\"\0004\4\3\0005\5\29\0006\6\30\0009\6\31\0069\6 \6\25\6\0\6=\6!\5>\5\1\4=\4\r\0034\4\0\0=\4\15\0034\4\0\0=\4\17\0034\4\0\0=\4\19\0034\4\0\0=\4\21\0034\4\0\0=\4\23\3=\3#\0024\3\0\0=\3$\2B\0\2\1K\0\1\0\15extensions\ftabline\1\0\0\15max_length\fcolumns\6o\bvim\1\2\1\0\ttabs\tmode\3\2\22inactive_sections\1\2\0\0\rlocation\1\2\0\0\rfilename\1\0\0\rsections\14lualine_z\1\2\0\0\rlocation\14lualine_y\1\2\0\0\rprogress\14lualine_x\1\4\0\0\15fileformat\rfiletype\rencoding\14lualine_c\1\2\0\0\rfilename\14lualine_b\1\4\0\0\vbranch\tdiff\16diagnostics\14lualine_a\1\0\0\1\2\0\0\tmode\foptions\1\0\0\23disabled_filetypes\23section_separators\1\0\2\tleft\bî‚°\nright\bî‚²\25component_separators\1\0\2\tleft\bî‚±\nright\bî‚³\1\0\3\25always_divide_middle\2\ntheme\tauto\18icons_enabled\2\nsetup\flualine\frequire\6\0", "config", "lualine.nvim")
time([[Config for lualine.nvim]], false)
vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType fish ++once lua require("packer.load")({'vim-fish'}, { ft = "fish" }, _G.packer_plugins)]]
vim.cmd [[au FileType toml ++once lua require("packer.load")({'crates.nvim'}, { ft = "toml" }, _G.packer_plugins)]]
vim.cmd [[au FileType markdown ++once lua require("packer.load")({'markdown-preview.nvim'}, { ft = "markdown" }, _G.packer_plugins)]]
vim.cmd [[au FileType tex ++once lua require("packer.load")({'tex-conceal.vim', 'vimtex'}, { ft = "tex" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
vim.cmd("augroup END")
vim.cmd [[augroup filetypedetect]]
time([[Sourcing ftdetect script at: /home/aikow/.local/share/nvim/site/pack/packer/opt/vim-fish/ftdetect/fish.vim]], true)
vim.cmd [[source /home/aikow/.local/share/nvim/site/pack/packer/opt/vim-fish/ftdetect/fish.vim]]
time([[Sourcing ftdetect script at: /home/aikow/.local/share/nvim/site/pack/packer/opt/vim-fish/ftdetect/fish.vim]], false)
time([[Sourcing ftdetect script at: /home/aikow/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/cls.vim]], true)
vim.cmd [[source /home/aikow/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/cls.vim]]
time([[Sourcing ftdetect script at: /home/aikow/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/cls.vim]], false)
time([[Sourcing ftdetect script at: /home/aikow/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/tex.vim]], true)
vim.cmd [[source /home/aikow/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/tex.vim]]
time([[Sourcing ftdetect script at: /home/aikow/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/tex.vim]], false)
time([[Sourcing ftdetect script at: /home/aikow/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/tikz.vim]], true)
vim.cmd [[source /home/aikow/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/tikz.vim]]
time([[Sourcing ftdetect script at: /home/aikow/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/tikz.vim]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
