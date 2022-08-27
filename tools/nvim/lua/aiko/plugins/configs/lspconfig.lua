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
-- | Mappings
-- ------------------------------------------------------------------------
M.mappings = function()
  local map = vim.keymap.set
  local opts = function(desc)
    return {
      silent = true,
      buffer = true,
      desc = desc or "",
    }
  end

  local lsp = vim.lsp.buf
  local d = vim.diagnostic

  -- Hover actions
  map("n", "K", lsp.hover, opts("show documentation"))
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

  -- Borders for LspInfo window
  -- local win = require("lspconfig.ui.windows")
  -- local _default_opts = win.default_opts
  --
  -- win.default_opts = function(options)
  --   local opts = _default_opts(options)
  --   opts.border = "single"
  --   return opts
  -- end
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
    "sqls",
    "taplo",
    "vimls",
    "yamlls",
  }

  -- Basic language servers
  for _, ls in pairs(servers) do
    lspconfig[ls].setup({
      on_attach = M.on_attach,
      capabilities = capabilities,
    })
  end

  -- M.grammarly(lspconfig)
  M.ltex(lspconfig)

  M.sumneko_lua(lspconfig)
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

-- ------------------------------------------------------------------------
-- | Lua LSP Config
-- ------------------------------------------------------------------------
M.sumneko_lua = function(lspconfig)
  -- Setup configuration for neovim.
  local setup_neovim_libraries = function()
    -- Add all library paths from vim's runtime path.
    local library = {}
    local packer_dir = vim.fn.stdpath("data") .. "/site/pack/packer/*/*/lua"

    for path in string.gmatch(vim.fn.glob(packer_dir), "[^\n]+") do
      if vim.fn.empty(vim.fn.glob(path)) == 0 then
        library[path] = true
      end
    end

    library[vim.fn.expand("$VIMRUNTIME/lua")] = true
    library[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true

    return library
  end

  --- Adds a custom hook on initialization that only adds the library path's if
  -- the current working directory is the nvim directory.
  local on_init = function(client)
    local workspace = client.workspace_folders[1].name

    local config = client.config.settings.Lua

    if string.match(workspace, [[.dotfiles/os/awesome$]]) then
      -- Awesome WM Configs
      -- Setup global variables
      config.diagnostics.globals = { "awesome", "client", "screen", "root" }
      -- if string.match(workspace, [[.dotfiles/tools/nvim$]]) then
    else
      -- Neovim configs
      -- setup libraries
      config.workspace.library = setup_neovim_libraries()

      -- Setup global variables
      local diagnostics = config.diagnostics or {}
      diagnostics.globals = { "vim" }
      config.diagnostics = diagnostics
    end

    return true
  end

  local capabilities = M.capabilities()
  capabilities.documentFormatingProvider = false

  lspconfig.sumneko_lua.setup({
    on_attach = M.on_attach,
    on_init = on_init,
    capabilities = capabilities,
    settings = {
      Lua = {
        format = {
          enable = true,
          -- All values must be of type string.
          defaultConfig = {
            indent_style = "space",
            indent_size = "2",
          },
        },
        workspace = {
          maxPreload = 100000,
          preloadFileSize = 10000,
        },
      },
    },
  })
end

return M
