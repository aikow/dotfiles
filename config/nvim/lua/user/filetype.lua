vim.filetype.add({
  extension = {
    just = "just",
    nu = "nu",
    rsync = "rsync",
    tmux = "tmux",
    wiki = "markdown",
  },
  filename = {
    [".gitignore"] = "gitignore",
    [".rsync-filter"] = "rsync",
    ["aliases"] = "sh",
    ["bashrc"] = "bash",
    ["gitconfig"] = "gitconfig",
  },
  pattern = {
    ["[Dd]ockerfile.*"] = "dockerfile",

    -- Case-insensitive match.
    ["[Mm][Aa][Nn][Ii][Ff][Ee][Ss][Tt]%.in"] = "manifest",

    ["%.?[Jj][Uu][Ss][Tt][Ff][Ii][Ll][Ee]"] = "just",

    -- Fallback matching on file contents.
    [".*"] = {
      priority = -math.huge,
      function(_, bufnr)
        local line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ""
        if vim.regex([[\v^#!.*/bin/(env\s+)?nu>]]):match_str(line) ~= nil then
          return "nu"
        end
      end,
    },
  },
})
