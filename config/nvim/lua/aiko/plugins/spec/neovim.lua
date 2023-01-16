return {
  -- Lua
  {
    "rafcamlet/nvim-luapad",
    cmd = { "Luapad", "LuaRun" },
  },

  -- Neovim development with lua.
  {
    "folke/neodev.nvim",
    enabled = true,
    ft = { "lua" },
    config = function()
      require("neodev").setup({})
    end,
  },
}
