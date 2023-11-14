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
}
