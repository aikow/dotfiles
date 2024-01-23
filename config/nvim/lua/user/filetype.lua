vim.filetype.add({
  extension = {
    dvc = "yaml",
    just = "just",
    log = "log",
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
    [".*/%.dvc/config"] = "gitconfig",
    ["[Dd]ockerfile.*"] = "dockerfile",
    ["%.?justfile"] = "just",
    ["requirements-.*%.txt"] = "requirements",
    [".*/requirements/[^/]+%.txt"] = "requirements",

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
