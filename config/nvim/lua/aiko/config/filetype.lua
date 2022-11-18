vim.filetype.add({
  extension = {
    nu = "nu",
    rsync = "rsync",
    tmux = "tmux",
    wiki = "markdown",
  },
  filename = {
    [".gitignore"] = "gitignore",
    ["aliases"] = "sh",
    ["bashrc"] = "bash",
    ["gitconfig"] = "gitconfig",
  },
  pattern = {
    ["[Dd]ockerfile.*"] = "dockerfile",

    -- Case-insensitive match.
    ["[Mm][Aa][Nn][Ii][Ff][Ee][Ss][Tt]%.in"] = "manifest",

    -- Fallback matching on file contents.
    [".*"] = {
      priority = -math.huge,
      function(_, bufnr)
        local line = vim.filetype.getlines(bufnr, 1)
        if vim.filetype.matchregex(line, [[\v^#!.*/bin/(env\s+)?nu>]]) then
          return "nu"
        end
      end,
    },
  },
})
