local M = {}

M.setup = function()
  local map = vim.keymap.set
  local opts = function(desc)
    return {
      silent = true,
      buffer = true,
      desc = desc or "",
    }
  end

  local crates = require("crates")
  crates.setup()

  map("n", "<localleader>t", crates.toggle, opts("crates toggle menu"))
  map("n", "<localleader>r", crates.reload, opts("crates reload source"))

  map("n", "<localleader>v", crates.show_versions_popup, opts("crates show versions popup"))
  map("n", "<localleader>f", crates.show_features_popup, opts("crates show features popup"))

  -- Update crates
  map("n", "<localleader>u", crates.update_crates, opts("crates update"))
  map("n", "<localleader>U", crates.update_all_crates, opts("crates update all"))
  map("n", "<localleader>g", crates.upgrade_crates, opts("crates upgrade"))
  map("n", "<localleader>G", crates.upgrade_all_crates, opts("crates upgrade all"))
end

return M
