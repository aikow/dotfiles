vim.filetype.add({
  extension = {
    dvc = "yaml",
    log = "log",
    rsync = "rsync",
    tmux = "tmux",
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
    ["requirements-.*%.txt"] = "requirements",

    [".*"] = {
      function(path, buf)
        return vim.bo[buf]
            and vim.bo[buf].filetype ~= "bigfile"
            and path
            and (function()
              local stat = vim.uv.fs_stat(path)
              return stat and stat.size > 2097152 -- 2MB
            end)()
            and "bigfile"
          or nil
      end,
    },
  },
})
