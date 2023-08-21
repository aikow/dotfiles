return {
  -- Rust
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    config = function()
      local ok_rust_tools, rust_tools = pcall(require, "rust-tools")
      if not ok_rust_tools then
        return
      end

      local ok_cmp_nvim_lsp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if not ok_cmp_nvim_lsp then
        return
      end

      local capabilities = cmp_lsp.default_capabilities(
        vim.lsp.protocol.make_client_capabilities()
      )

      rust_tools.setup({
        tools = { -- rust-tools options
          autoSetHints = true, -- Automatically set inlay hints
          -- hover_with_actions = true, -- Show action inside the hover menu
          inlay_hints = {
            show_parameter_hints = true, -- Show parameter hints
            parameter_hints_prefix = "<- ",
            other_hints_prefix = "=> ",
          },
        },
        -- These override the defaults set by rust-tools.nvim.
        -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
        server = {
          -- on_attach = function()
          --   require("user.plugins.configs.lspconfig").mappings()
          -- end,
          capabilities = capabilities,
          settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
              -- enable clippy on save
              checkOnSave = {
                command = "clippy",
              },
            },
          },
        },
      })
      local map = vim.keymap.set

      -- stylua: ignore start
      map("n", "<localleader>d", "<cmd>RustOpenExternalDocs<CR>", { silent = true, desc = "rust open external docs" })
      map("n", "<localleader>t", "<cmd>RustDebuggables<CR>", { silent = true, desc = "rust debuggables" })
      map("n", "<localleader>r", "<cmd>RustRunnables<CR>", { silent = true, desc = "rust runnables" })
      map("n", "<localleader>c", "<cmd>RustOpenCargo<CR>", { silent = true, desc = "rust open cargo" })
      map("n", "<localleader>m", "<cmd>RustExpandMacro<CR>", { silent = true, desc = "rust expand macro" })
      map("n", "<localleader>a", "<cmd>RustHoverActions<CR>", { silent = true, desc = "rust hover actions" })
      -- stylua: ignore end
    end,
  },

  -- Cargo.toml files and interacting with `crates.io`.
  {
    "saecki/crates.nvim",
    ft = "toml",
    version = "*",
    opts = {},
    config = function(_, opts)
      local crates = require("crates")
      crates.setup(opts)

      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "Cargo.toml",
        callback = function()
          local map = vim.keymap.set
          local map_opts = function(desc)
            return {
              silent = true,
              buffer = true,
              desc = desc or "",
            }
          end

          -- stylua: ignore start
          map("n", "<localleader>t", crates.toggle, map_opts("crates toggle menu"))
          map("n", "<localleader>r", crates.reload, map_opts("crates reload source"))
          map("n", "K", crates.show_popup, map_opts("crates show popup"))
          map("n", "<localleader>v", crates.show_versions_popup, map_opts("crates show versions popup"))
          map("n", "<localleader>f", crates.show_features_popup, map_opts("crates show features popup"))
          map("n", "<localleader>u", crates.update_crates, map_opts("crates update"))
          map("n", "<localleader>U", crates.update_all_crates, map_opts("crates update all"))
          map("n", "<localleader>g", crates.upgrade_crates, map_opts("crates upgrade"))
          map("n", "<localleader>G", crates.upgrade_all_crates, map_opts("crates upgrade all"))
          -- stylua: ignore end
        end,
      })
    end,
  },

  -- Latex
  {
    "lervag/vimtex",
    ft = { "tex" },
    config = function()
      vim.g.tex_flavor = "latex"

      vim.g.vimtex_view_method = "zathura"

      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = {
        out_dir = "build",
        callback = 1,
        continuous = 1,
        executable = "latexmk",
        hooks = {},
        options = {
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
        },
      }

      vim.api.nvim_create_user_command("LatexSurround", function()
        vim.b["surround" .. vim.fn.char2nr("e")] =
          [[\\begin{\1environment: \1}\n\t\r\n\\end{\1\1}]]
        vim.b["surround" .. vim.fn.char2nr("c")] = [[\\\1command: \1{\r}]]
      end, { nargs = 0 })
    end,
  },

  -- Justfile support syntax support.
  --
  -- Currently the vim syntax support works a lot better than the tree-sitter
  -- based one.
  {
    "NoahTheDuke/vim-just",
    ft = { "just" },
  },

  {
    "IndianBoy42/tree-sitter-just",
    enabled = false,
    dependencies = { "nvim-treesitter" },
    ft = { "just" },
    opts = {},
  },

  -- Markdown
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },

  -- Fish shell syntax support.
  {
    "aikow/vim-fish",
    ft = { "fish" },
  },

  -- Syntax support for nushell.
  {
    "LhKipp/nvim-nu",
    dependencies = {
      "null-ls.nvim",
      "nvim-treesitter",
    },
    ft = { "nu" },
    opts = {
      use_lsp_features = true,
    },
  },

  -- CSV helper plugin.
  {
    "chrisbra/csv.vim",
    ft = { "csv", "tsv" },
    config = function()
      vim.g.csv_bind_B = 1
    end,
  },

  -- Connect to databases inside Neovim.
  {
    "tpope/vim-dadbod",
    ft = { "sql", "msql", "mysql", "plsql" },
    cmd = { "DB" },
  },

  -- Nvim Org mode plugin.
  {
    "nvim-neorg/neorg",
    dependencies = {
      "nvim-treesitter",
      "nvim-neorg/neorg-telescope",
    },
    -- version = "*",
    ft = { "norg" },
    cmd = { "Neorg" },
    build = ":Neorg sync-parsers",
    opts = {
      load = {
        -- Load all default modules
        ["core.defaults"] = {},

        -- Remove leading whitespace when yanking a code-block.
        ["core.clipboard.code-blocks"] = {},

        -- Customize the core completion module to use nvim-cmp.
        ["core.completion"] = {
          config = {
            engine = "nvim-cmp",
          },
        },

        -- Replace some Neorg markup notation with fancy icons.
        ["core.concealer"] = {},

        -- Manage directories and workspaces.
        ["core.dirman"] = {
          config = {
            workspaces = {
              personal = "~/gdrive/notes",
              notes = "~/notes",
            },
            index = "index.norg",
          },
        },

        -- Convert Neorg files to other formats like markdown.
        ["core.export"] = {},

        -- Enable the Telescope integration.
        ["core.integrations.telescope"] = {},

        -- Easily continue a Neorg item on the next line.
        ["core.itero"] = {},

        -- Configure the default keybindings.
        ["core.keybinds"] = {
          config = {
            default_keybinds = true,
            neorg_leader = "<localleader>",
            -- stylua: ignore
            hook = function(keybinds)
              keybinds.map("norg", "n", "<localleader>mi", "<cmd>Neorg inject-metadata<CR>")
              keybinds.map("norg", "n", "<localleader>mu", "<cmd>Neorg update-metadata<CR>")
              keybinds.map("norg", "n", "<localleader>t", "<cmd>Neorg tangle current-file<CR>")

              -- Telescope
              keybinds.map("norg", "i", "<C-l>", "<cmd>Telescope neorg insert_link<CR>")
              keybinds.map("norg", "i", "<C-h>", "<cmd>Telescope neorg insert_file_link<CR>")

              keybinds.map("norg", "n", "<localleader>fo", "<cmd>Telescope neorg find_norg_files<CR>")
              keybinds.map("norg", "n", "<localleader>fl", "<cmd>Telescope neorg find_linkable<CR>")
              keybinds.map("norg", "n", "<localleader>fh", "<cmd>Telescope neorg find_headings<CR>")

              -- Looking glass
              keybinds.map_event("norg", "n", "<localleader>c", "core.looking-glass.magnify-code-block")
            end,
          },
        },

        -- Allows editing code-blocks in a separate buffer of that filetype.
        ["core.looking-glass"] = {},

        -- Easily toggle between the two list types.
        ["core.pivot"] = {},

        -- Enable a fancy presenter mode for showing off Neorg documents.
        ["core.presenter"] = {
          config = {
            zen_mode = "zen-mode",
          },
        },

        -- Shortcuts for increasing and decreasing the nesting level of Neorg
        -- items.
        ["core.promo"] = {},

        -- Generate a table-of-contents dynamically.
        ["core.qol.toc"] = {},

        -- Generate a summary of the workspace.
        ["core.summary"] = {},

        -- Allows piping the contents of codeblocks into multiple different files.
        ["core.tangle"] = {},

        -- Enable the date picker.
        ["core.ui.calendar"] = {},
      },
    },
  },

  -- Kitty .conf file syntax support.
  {
    "fladson/vim-kitty",
  },
}
