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
    -- FIXME: Once I can install the just tree-sitter parser on mac, switch it
    -- back to "just"
    ["justfile"] = "make",
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
