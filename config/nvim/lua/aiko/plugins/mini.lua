return {
  {
    "echasnovski/mini.nvim",
    version = false,
    opts = {
      align = {},
      comment = {},
      splitjoin = {
        mappings = {
          toggle = "gS",
        },
      },
      surround = {
        mappings = {
          add = "gs",
          delete = "ds",
          find = "",
          find_left = "",
          highlight = "gsh",
          replace = "cs",
          update_n_lines = "",
          suffix_last = "l",
          suffix_next = "n",
        },
      },
    },
    config = function(_, opts)
      for mod, o in pairs(opts) do
        require("mini." .. mod).setup(o)
      end
    end,
  },
}
