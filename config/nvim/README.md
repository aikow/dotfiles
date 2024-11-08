# Neovim

## Tree-Sitter Parsers

### `cc1plus` Errors

With an active conda environment, the python `gcc` package can cause issues when trying to install
parsers. Simply deactivating the conda environment should fix them.

### `c++11 extension` errors

**Solution: ** start nvim with a more modern C compiler.

```bash
CC='zig cc --std17' nvim +TSUpdateSync
```
