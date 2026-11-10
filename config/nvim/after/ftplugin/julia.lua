vim.bo.shiftwidth = 4

-- Julia strings interpolate `$`; encode every byte so filenames stay literal,
-- including quotes, backslashes, control characters, and non-ASCII UTF-8.
local function julia_string(value)
  return '"' .. value:gsub(".", function(byte) return ("\\x%02x"):format(byte:byte()) end) .. '"'
end

local function send_include(how)
  return function()
    local bufname = vim.api.nvim_buf_get_name(0)
    local relpath = vim.fs.relpath(vim.uv.cwd(), bufname)
    if not relpath then
      vim.notify(
        "cannot send current buffer, since it is not in the working directory",
        vim.log.levels.WARN
      )
      return
    end

    vim.fn["slime#send"](string.format("%s(%s)\n", how, julia_string(relpath)))
  end
end

-- Include Julia's mutating function names in both textobjects and surrounds.
local function_call = require("mini.ai").gen_spec.function_call({ name_pattern = "[%w_%.!]" })
vim.b.miniai_config = {
  custom_textobjects = { f = function_call },
}
vim.b.minisurround_config = {
  custom_surroundings = { f = { input = function_call } },
}

-- stylua: ignore start
vim.keymap.set("n", "<leader>kI", send_include("include"),  { desc = "Send the current file with include", buffer = true })
vim.keymap.set("n", "<leader>kR", send_include("includet"), { desc = "Send the current file with includet", buffer = true })
-- stylua: ignore end

require("user.ftplugin").undo({
  "setlocal shiftwidth<",
  "unlet! b:miniai_config b:minisurround_config",
  "silent! nunmap <buffer> <leader>kI",
  "silent! nunmap <buffer> <leader>kR",
})
