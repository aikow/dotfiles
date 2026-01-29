MiniDeps.now(function()
  -- Small helper function to create a new section.
  local function section(section_name, name, action)
    return { section = section_name, name = name, action = action }
  end

  local ver = vim.version()
  local footer = string.format("v%s.%s.%s", ver.major, ver.minor, ver.patch)
  if ver.prerelease then footer = footer .. "-" .. ver.prerelease end
  if ver.build and ver.build ~= vim.NIL then footer = footer .. "+" .. ver.build end

  local starter = require("mini.starter")
  starter.setup({
    evaluate_single = true,
    header = "Good morning, Aiko",
    items = {
      starter.sections.recent_files(5, true),
      starter.sections.builtin_actions(),

      -- Config
      section("Config", "Config", "cd ~/.dotfiles/config/nvim | edit init.lua"),
      section(
        "Config",
        "Local Config",
        string.format("cd %s | edit %s", vim.g.localrtp, vim.g.localrc)
      ),
    },
    footer = footer,
    content_hooks = {
      starter.gen_hook.adding_bullet("❭ ", false),
      starter.gen_hook.aligning("center", "center"),
    },
  })

  vim.keymap.set("n", "<leader>mo", starter.open, { desc = "mini.starter open" })
end)
