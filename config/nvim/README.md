# Neovim

## Local Configurations

> ![WARNING]
> Modifying the `'runtimepath'` from a file in a `plugin/` dir currently does
> not work.

### System-local Configuration

There are 2 ways to configure system wide settings. In source-order, they are

1. The `~/.local/config/nvim/local.lua` file
2. The `~/.local/config/nvim/after/` runtimepath directory

The `local.lua` file is sourced right after everything else from the main
`init.lua` file is sourced.

The `~/.local/config/nvim/after/` directory is sourced after _all_ other
`*/after/` runtimepath directories have been sourced.

Since options are currently all set from within the
`~/.config/nvim/after/plugin/options.lua` file, you'll either need to create
a `VimEnter` autocommand or override any settings in from a file in the local
runtimepath file.

### Project-local Configuration

`.nvim.lua`, `.nvimrc` and `.exrc` files are automatically sourced. You can
override options set in the runtimepath files using a `VimEnter` autocommand.
LSP settings can be configured directly. The colorscheme can also be set
directly, since it is isn't set anywhere.

## Tree-Sitter Parsers

### `cc1plus` Errors

With an active conda environment, the python `gcc` package can cause issues when trying to install
parsers. Simply deactivating the conda environment should fix them.

### `c++11 extension` errors

**Solution: ** start nvim with a more modern C compiler.

```bash
CC='zig cc --std17' nvim +TSUpdateSync
```
