# Neovim

This configuration currently targets Neovim 0.13 development builds. It uses
`vim.pack`, `MiniMisc.safely`, and development-runtime features such as
`TextPutPost`, `vim.hl.hl_op`, and the optional private `vim._core.ui2` UI. Stable
Neovim releases are not currently a compatibility target.

## Layout and loading

- `init.lua` bootstraps mini.nvim, defines `gh()` and `safely()`, configures the
  runtime paths, enables project-local configuration, and sources `local.lua`.
- `plugin/10_options.lua` through `plugin/50_commands.lua` configure options,
  built-in plugins, autocommands, mappings, and commands in filename order.
- `plugin/60_plugins/` configures external plugins. Its `00_mini/` directory groups
  mini.nvim modules into `ui.lua`, `editing.lua`, `completion.lua`, and `git.lua`,
  alongside the dedicated clue, file-browser, picker, and starter configs.
- `after/ftplugin/` contains buffer-specific settings. Each file appends cleanup to
  `b:undo_ftplugin` through `require('user.ftplugin').undo(...)`, preserving the
  runtime's existing cleanup when a buffer changes filetype. Shell `isfname` and
  Python indentation settings are global and continue to apply across buffers.
- `after/lsp/` extends language-server definitions supplied by nvim-lspconfig.
- `after/queries/` extends Tree-sitter injections and textobjects.

`MiniMisc.safely('now', callback)` runs setup immediately;
`MiniMisc.safely('later', callback)` defers it. Deferred setup is still startup
work, rather than loading a plugin only when its feature is first used.

Packages are managed by `vim.pack`, with revisions recorded in
`nvim-pack-lock.json`. See `:help vim.pack` for updating and reviewing packages.

## Local configurations

### Machine-local configuration

The additional runtime root is `~/.local/config/nvim`:

1. `local.lua` is sourced at the end of `init.lua`, before runtime plugin files.
   Use it for early configuration and registering later hooks.
2. Files under `plugin/` in that root are found before this config's plugin files;
   later settings here can overwrite them.
3. Files under `after/plugin/` in that root run after the other runtime plugins and
   after directories. Use these for final machine-specific overrides.

For example, place option overrides in
`~/.local/config/nvim/after/plugin/local.lua`. For settings changed by deferred
plugin setup, use a later callback or the relevant plugin event. Runtime-path
roots are established in `init.lua` so their runtime files can be discovered
consistently.

### Project-local configuration

With `exrc` enabled, trusted `.nvim.lua`, `.nvimrc`, and `.exrc` files can be loaded
from the startup directory. See `:help 'exrc'` and `:help :trust`.

Review these files before trusting them: they execute with your user permissions.
Project configuration should account for runtime plugins and filetype plugins
that can set options later; use a relevant event or a late callback for overrides.
LSP configuration can use `vim.lsp.config()`.

## External tools

Install `rg` for grep and `fd` for file discovery and ignore-aware mini.files
filtering. mini.files batches each directory's ignore check into one `fd` process
and uses NUL-delimited filenames. If `fd` fails, it warns and falls back to the
normal directory entries with the current hidden-file setting.

Language servers and formatters are separate executables. Mason installs and
enables managed servers; `jetls`, `nushell`, and `rust_analyzer` are explicitly
enabled for installations outside Mason. Formatting uses Conform and the tools
listed in `plugin/60_plugins/21_formatting.lua`.

REPL actions use vim-slime with tmux or Neovim terminals. Julia's include mappings
send a byte-escaped string literal so filenames cannot interpolate Julia code.

## Tree-sitter parsers

- `:TSInstallEssential` installs the parser list in
  `plugin/60_plugins/10_treesitter.lua`.
- `:TSInstallAll` installs all available parsers; this can be a large download.
- `:TSUpdate` updates installed parsers.

If parser builds fail with `cc1plus` errors inside a conda environment, deactivate
that environment and retry with your system C/C++ toolchain. For C++ standard
errors, select a sufficiently recent compiler through `CC`/`CXX` before launching
Neovim. For example, if installed: `CC=clang CXX=clang++ nvim`.

## Linux AppImage installer

`scripts/install --tag nightly` installs the Linux x86-64 AppImage;
`--tag vMAJOR.MINOR.PATCH` selects a release. Add `--extract` for machines without
FUSE, or `--force` to replace a cached download.

The script requires Bash, curl, jq, GNU coreutils/findutils, and rsync. It downloads
only over HTTPS and requires a SHA-256 digest from the official
[Neovim release-asset metadata](https://api.github.com/repos/neovim/neovim/releases/tags/nightly).
It verifies both new and cached AppImages before making them executable or
extracting them. Releases without digest metadata fail closed. The digest checks
integrity against GitHub's metadata; it is not an independent publisher signature.

Downloads are staged in a temporary directory and cleaned up on exit. A failed
HTTP request or checksum mismatch does not update the active installation or
launcher. A same-day nightly update can invalidate a cached image; rerun with
`--force` to download its replacement. The launcher points to a fixed filename,
and only date-named nightly cache directories are eligible for cleanup.

## Performance and checks

Use [`benchmark/`](benchmark/README.md) for Hyperfine startup and buffer-load
comparisons. When evaluating deferred setup, also check readiness in an
interactive session; a headless startup measurement alone does not describe the
whole editing experience.

From this directory, `just ts-lint` checks custom queries and `just format` formats
Lua, queries, and spell lists. The latter modifies files. `just plugin-stats`
reports installed plugin sizes and requires Nushell and tokei.
