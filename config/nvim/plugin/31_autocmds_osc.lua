local H = {}

H.handle_theme_change = function(theme)
  vim.schedule(function()
    if vim.o.background == theme then return end
    vim.o.background = theme
    vim.cmd("redraw!")
  end)
end

H.parse_osc_color_response = function(sequence)
  if type(sequence) ~= "string" then return nil end
  -- TermResponse includes ESC ] but omits the OSC terminator.
  -- Each RGB component contains one to four hexadecimal digits.
  local command, r, g, b = sequence:match("^\027%](1[01]);rgb:(%x+)/(%x+)/(%x+)$")

  if r and g and b then
    -- Convert hex to decimal and calculate luminance
    local rr = tonumber(r, 16) / (16 ^ #r - 1)
    local gg = tonumber(g, 16) / (16 ^ #g - 1)
    local bb = tonumber(b, 16) / (16 ^ #b - 1)

    -- Same luminance calculation that Neovim uses
    local luminance = (0.299 * rr) + (0.587 * gg) + (0.114 * bb)
    return command, luminance
  end

  return nil
end

H.query_terminal_theme = function()
  -- mini.misc changes OSC11 background, but leaves OSC10 foreground intact.
  vim.api.nvim_ui_send("\027]10;?\007")
end

local group = vim.api.nvim_create_augroup("user.terminal.theme", { clear = true })

vim.api.nvim_create_autocmd("TermResponse", {
  group = group,
  pattern = "*",
  callback = function(args)
    local command, luminance = H.parse_osc_color_response(args.data.sequence)
    if command == "11" then
      -- Neovim queries OSC11 after a mode-2031 theme-change notification.
      H.query_terminal_theme()
    elseif command == "10" then
      -- Dark text implies a light theme; light text implies a dark theme.
      H.handle_theme_change(luminance < 0.5 and "light" or "dark")
    end
  end,
})

vim.api.nvim_create_autocmd({ "VimEnter", "VimResume", "FocusGained" }, {
  group = group,
  callback = H.query_terminal_theme,
})
