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
          on_attach = function()
            require("aiko.plugins.configs.lspconfig").mappings()
            M.mappings()
          end,
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
    config = function()
      local crates = require("crates")
      crates.setup()

      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "Cargo.toml",
        callback = function()
          local map = vim.keymap.set
          local opts = function(desc)
            return {
              silent = true,
              buffer = true,
              desc = desc or "",
            }
          end

          -- stylua: ignore start
          map("n", "<localleader>t", crates.toggle, opts("crates toggle menu"))
          map("n", "<localleader>r", crates.reload, opts("crates reload source"))
          map("n", "K", crates.show_popup, opts("crates show popup"))
          map("n", "<localleader>v", crates.show_versions_popup, opts("crates show versions popup"))
          map("n", "<localleader>f", crates.show_features_popup, opts("crates show features popup"))
          map("n", "<localleader>u", crates.update_crates, opts("crates update"))
          map("n", "<localleader>U", crates.update_all_crates, opts("crates update all"))
          map("n", "<localleader>g", crates.upgrade_crates, opts("crates upgrade"))
          map("n", "<localleader>G", crates.upgrade_all_crates, opts("crates upgrade all"))
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
      -- vim.g.vimtex_view_method = "sioyek"

      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = {
        build_dir = "build",
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

  -- Justfile support with tree-sitter.
  {
    "IndianBoy42/tree-sitter-just",
    config = function()
      require("tree-sitter-just").setup({})
    end,
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
    },
    ft = { "nu" },
    config = function()
      require("nu").setup({
        use_lsp_features = true,
      })
    end,
  },

  -- CSV helper plugin.
  {
    "chrisbra/csv.vim",
    ft = { "csv", "tsv" },
  },

  -- Connect to databases inside Neovim
  {
    "tpope/vim-dadbod",
    ft = { "sql", "msql", "mysql", "plsql" },
    cmd = { "DB" },
  },

  -- Lua
  {
    "rafcamlet/nvim-luapad",
    cmd = { "Luapad", "LuaRun" },
  },

  -- Nvim Org mode plugin.
  {
    "nvim-neorg/neorg",
    version = "*",
    ft = { "norg" },
    cmd = { "Neorg" },
    dependencies = { "nvim-neorg/neorg-telescope" },
    config = function()
      local ok_neorg, neorg = pcall(require, "neorg")
      if not ok_neorg then
        return
      end

      neorg.setup({
        load = {
          -- Builtin modules
          ["core.defaults"] = {},
          ["core.keybinds"] = {
            config = {
              default_keybinds = false,
              neorg_leader = "<localleader>",
            },
          },
          ["core.norg.dirman"] = {
            config = {
              workspaces = {
                personal = "~/GDrive/notes",
              },
            },
          },

          -- Disable the concealer for now
          ["core.norg.concealer"] = {},

          ["core.norg.completion"] = {
            config = {
              engine = "nvim-cmp",
            },
          },

          ["core.norg.qol.toc"] = {},

          -- --------------------
          -- |   Core modules   |
          -- --------------------
          ["core.presenter"] = {
            config = {
              zen_mode = "zen-mode",
            },
          },

          ["core.norg.journal"] = {
            config = {
              workspace = "personal",
              journal_folder = "journal",
              strategy = "nested",
            },
          },

          -- ---------------------------
          -- |   Getting Things Done   |
          -- ---------------------------
          -- ["core.gtd.base"] = {},

          -- External Modules
          ["core.integrations.telescope"] = {},
        },
      })
    end,
  },
}
