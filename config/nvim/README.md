# Neovim

My lua config files for Neovim.

## Getting Started

After linking, run `PackerSync` and restart neovim.

LuaSnip can support additional regex transformations, which can be enabled by
installing `jsregexp` package from luarocks.

To install it globally, use 

```bash
sudo luarocks install jsregexp
```

Or to install it locally for the current user, use

```bash
luarocks install --local jsregexp
```

## To Do

- [ ] Cleanup LSP config
- [ ] Clean up the status line by generalizing modules

## Tree-Sitter Parsers

### `cc1plus` Errors

With an active conda environment, the python `gcc` package can cause issues.
Simply deactivating the conda environment should fix them.

### `c++11 extension` errors

On macos, start nvim with
```bash
CC=gcc-12 nvim
```
to use the gcc-12 compiler.
