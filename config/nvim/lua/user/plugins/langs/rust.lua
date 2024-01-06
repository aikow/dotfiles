return {
  -- Rust
  {
    "mrcjkb/rustaceanvim",
    ft = "rust",
    init = function()
      vim.g.rustaceanvim = {
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
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = {
                command = "clippy",
              },
            },
          },
        },
      }
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
