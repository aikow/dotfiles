local S = {}

S.on_init = function(client)
  local spellpath = vim.fn.expand("~/.dotfiles/config/nvim/spell/en.utf-8.add")
  local spellfile = io.open(spellpath, "r")
  if not spellfile then
    return
  end

  -- Construct English dictionary by reading the spell file.
  local dict_en = vim.split(spellfile:read("*a"), "\n", { trimempty = true })
  table.insert(dict_en, ":" .. spellpath)

  client.config.settings.ltex.dictionary = {
    ["en-US"] = dict_en,
  }

  -- Setup an auto-command that detects when a word was added to the spell
  -- file to reload the language server.
  vim.api.nvim_create_autocmd("FileChangedShellPost", {
    group = vim.api.nvim_create_augroup(
      "LTeX update dictionary",
      { clear = true }
    ),
    pattern = spellpath,
    callback = function()
      print("Updated spell file")
    end,
  })
end

S.filetypes = {
  "bib",
  -- "gitcommit",
  -- "markdown",
  -- "norg",
  -- "org",
  "plaintex",
  -- "rnoweb",
  -- "rst",
  "tex",
}

S.settings = {
  ltex = {
    additionalRules = {
      enablePickyRules = true,
    },
    completionEnabled = true,
    enabledRules = {
      ["en-US"] = {},
    },
    language = "en-US",
    latex = {
      commands = {
        ["\\token{}"] = "dummy",
        ["\\dataset{}"] = "dummy",
        ["\\langset{}"] = "dummy",
        ["\\punctset{}"] = "dummy",
        ["\\encoding{}"] = "dummy",
        ["\\extext{}"] = "dummy",
        ["\\ltokenize{}"] = "dummy",
        ["\\csvreader[]{}{}{}"] = "ignore",
        ["\\gls{}"] = "dummy",
        ["\\glspl{}"] = "dummy",
        ["\\glsdesc{}"] = "dummy",
        ["\\Gls{}"] = "dummy",
        ["\\Glspl{}"] = "dummy",
        ["\\Glsdesc{}"] = "dummy",
      },
      environments = {
        ["tabular"] = "ignore",
      },
    },
  },
}

return S
