local tbl = require("aiko.util.table")

local M = {}

M.on_attach = function(client, bufnr)
  -- Setup navic component for status line.
  local ok_nvim_navic, nvim_navic = pcall(require, "nvim-navic")
  if ok_nvim_navic then
    nvim_navic.attach(client, bufnr)
  end

  M.mappings()
end

-- ------------------------------------------------------------------------
-- | On Init
-- ------------------------------------------------------------------------
M.on_init = function(client)
  local wks = require("aiko.workspace")
  local workspace_path = client.workspace_folders[1].name

  local config =
    wks.get_config(workspace_path, string.format("lsp/%s.json", client.name))

  if config.settings then
    local settings = client.config.settings
    client.config.settings = tbl.deep_type_extend(config.settings, settings)

    client.notify(
      "workspace/didChangeConfiguration",
      { settings = client.config.settings }
    )
    vim.notify("Loading workspace settings")
  end

  return true
end

-- ------------------------------------------------------------------------
-- | Mappings
-- ------------------------------------------------------------------------
M.mappings = function()
  local map = vim.keymap.set
  local opts = function(desc)
    return {
      silent = true,
      buffer = false,
      desc = desc or "",
    }
  end

  local lsp = vim.lsp.buf
  local d = vim.diagnostic

  -- Hover actions
  map("n", "K", function()
    local filetype = vim.bo.filetype
    if vim.tbl_contains({"help", "vim"}, filetype) then
      vim.cmd.help(vim.fn.expand("<cword>"))
    elseif vim.tbl_contains({"man"}, filetype) then
      vim.cmd.Man(vim.fn.expand("<cword>"))
    elseif vim.fn.expand("%:t") == "Cargo.toml" then
      require("crates").show_popup()
    else
      vim.lsp.buf.hover()
    end
  end, opts("show documentation"))
  map("n", "<leader>k", lsp.signature_help, opts("signature help"))

  -- Diagnostics
  map("n", "<leader>e", d.open_float, opts("open diagnostic float"))
  map({ "n", "v", "o" }, "[e", d.goto_prev, opts("go to previous diagnostic"))
  map({ "n", "v", "o" }, "]e", d.goto_next, opts("go to next diagnostic"))
  map("n", "<leader>dl", d.setloclist, opts("diagnostics set location list"))

  -- Code actions
  map("n", "<leader>a", lsp.code_action, opts("LSP code actions"))

  -- Refactoring with <leader>r...
  map("n", "<leader>rr", lsp.rename, opts("LSP rename"))
  map("n", "<leader>rf", lsp.format, opts("LSP format file"))
end

-- ------------------------------------------------------------------------
-- | UI Tweaks
-- ------------------------------------------------------------------------
M.ui = function()
  local function lspSymbol(name, icon)
    local hl = "DiagnosticSign" .. name
    vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
  end

  local icons = require("aiko.ui.icons")

  lspSymbol("Error", icons.diagnostics.error)
  lspSymbol("Info", icons.diagnostics.info)
  lspSymbol("Hint", icons.diagnostics.hint)
  lspSymbol("Warn", icons.diagnostics.warn)

  vim.diagnostic.config({
    virtual_text = {
      prefix = "",
    },
    signs = true,
    underline = true,
    update_in_insert = false,
  })

  -- Pretty borders for signature help and hover.
  vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, {
      border = "single",
    })

  vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = "single",
      focusable = false,
      relative = "cursor",
    })

  -- Suppress error messages from lang servers.
  vim.notify = function(msg, log_level)
    if msg:match("exit code") then
      return
    end
    if log_level == vim.log.levels.ERROR then
      vim.api.nvim_err_writeln(msg)
    else
      vim.api.nvim_echo({ { msg } }, true, {})
    end
  end
end

-- ------------------------------------------------------------------------
-- | Capabilities
-- ------------------------------------------------------------------------
M.capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  -- Setup nvim-cmp with lspconfig.
  local ok_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if ok_cmp_nvim_lsp then
    capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
  end

  capabilities.textDocument.completion.completionItem = {
    documentationFormat = { "markdown", "plaintext" },
    snippetSupport = true,
    preselectSupport = true,
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    deprecatedSupport = true,
    commitCharactersSupport = true,
    tagSupport = {
      valueSet = { 1 },
    },
    resolveSupport = {
      properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
      },
    },
  }

  return capabilities
end

-- ------------------------------------------------------------------------
-- | Setup LSP Servers
-- ------------------------------------------------------------------------
M.setup = function()
  -- Setup LSP installer before configuring the LSP servers.
  -- local ok_mason, mason = pcall(require, "mason")
  -- if not ok_mason then
  --   return
  -- end
  --
  -- mason.setup({})

  -- Require LSP config module.
  local ok_lspconfig, lspconfig = pcall(require, "lspconfig")
  if not ok_lspconfig then
    return
  end

  M.ui()

  -- Get the server capabilities.
  local capabilities = M.capabilities()

  local servers = {
    "bashls",
    "clangd",
    "gopls",
    "jsonls",
    "pyright",
    "taplo",
    "vimls",
    "yamlls",
  }

  -- Basic language servers
  for _, ls in pairs(servers) do
    lspconfig[ls].setup({
      on_attach = M.on_attach,
      on_init = M.on_init,
      capabilities = capabilities,
    })
  end

  M.sqls(lspconfig)

  M.ltex(lspconfig)

  require("aiko.plugins.configs.lspconfig.servers.sumneko_lua").setup(lspconfig)
end

M.sqls = function(lspconfig)
  local capabilities = M.capabilities()
  capabilities.documentFormatingProvider = false

  lspconfig.sqls.setup({
    on_attach = M.on_attach,
    on_init = M.on_init,
    capabilities = capabilities
  })
end

-- ------------------------------------------------------------------------
-- | LTeX LSP Config
-- ------------------------------------------------------------------------
M.ltex = function(lspconfig)
  local on_init = function(client)
    local spellpath = vim.fn.expand("~/.dotfiles/tools/nvim/spell/en.utf-8.add")
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

  lspconfig.ltex.setup({
    on_attach = M.on_attach,
    on_init = on_init,
    capabilities = M.capabilities(),
    filetypes = {
      "bib",
      -- "gitcommit",
      -- "markdown",
      -- "norg",
      -- "org",
      "plaintex",
      -- "rnoweb",
      -- "rst",
      "tex",
    },
    settings = {
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
    },
  })
end

return M
