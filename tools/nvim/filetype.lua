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
    ["justfile"] = "just",
    [".justfile"] = "just",
    ["MANIFEST.in"] = "manifest",
  },
  pattern = {
    ["Dockerfile.*"] = "dockerfile",
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
