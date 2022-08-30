# Neovim

My lua config files for Neovim.

## Getting Started

After linking, run `PackerSync` and restart neovim.

Additional LuaSnip can support additional regex transformations, which can be
enabled by installing `jsregexp`.

## To Do

- [ ] Cleanup LSP config.

## Structure

The config is split across multiple files with the basic idea for the Lua code
being as follows:

```text
 lua
└──  aiko
   ├──  config
   │  ├──  autocmds.lua   <- Sets up basic autocommands
   │  ├──  builtin.lua    <- Disables and configures some builtin plugins
   │  ├──  init.lua
   │  ├──  mappings.lua   <- Initializes all mappings
   │  ├──  neovide.lua    <- Config if using neovide
   │  └──  options.lua    <- Sets all options
   ├──  luasnip
   │  ├──  snips          <- The filetype specific snippets in lua
   │  └──  callbacks.lua  <- Code shared across multiple snippets
   ├──  plugins
   │  ├──  configs        <- Contains configuration for individual plugins
   │  ├──  init.lua       <- Bootstraps and initializes packer.nvim
   │  ├──  lazy.lua       <- Handles code for lazy loading
   │  └──  sources.lua    <- Returns a list of all plugins
   ├──  ui
   │  └──  icons.lua      <- Icons
   ├──  util              <- Common snippets that don't need to be repeated
   │  ├──  fn.lua
   │  └──  init.lua
   └──  init.lua          <- Calls all the other modules
```
