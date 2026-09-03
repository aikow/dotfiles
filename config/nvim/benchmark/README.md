# Neovim performance benchmarks

This is a portable Hyperfine harness for recording comparable Neovim startup and buffer-open measurements. It disables swap and ShaDa I/O by default, so ordinary comparisons concentrate on configuration, plugins, file loading, and option costs.

It needs `nvim`, `hyperfine`, and `jq` (only for comparisons). Results are stored outside the dotfiles checkout in `$XDG_STATE_HOME/nvim/benchmarks` or `~/.local/state/nvim/benchmarks`.

## Capture a baseline

Capture startup timing before a configuration change:

```sh
./benchmark/run.sh before-plugin
```

For a buffer-opening benchmark, include a representative file. Use the same file and number of runs for the before and after snapshots:

```sh
./benchmark/run.sh --file ~/src/project/large-file.rs before-plugin
# Enable or update the plugin/option.
./benchmark/run.sh --file ~/src/project/large-file.rs after-plugin
./benchmark/compare.sh ~/.local/state/nvim/benchmarks/before-plugin.json \
  ~/.local/state/nvim/benchmarks/after-plugin.json
```

Each snapshot includes both:

- `configured`: your complete Neovim configuration, which is the result to track when assessing plugins or options;
- `minimal`: `-u NONE -U NONE`, a control that helps identify machine or Neovim-version variation.

Use `--configured-only` when the control is unnecessary, and `--runs`/`--warmup` to tune confidence versus duration. Set `NVIM_BIN=/path/to/nvim` to compare a different Neovim executable on the same system.

## Include ShaDa

Use `--shada` to include your normal ShaDa file in a snapshot. This measures the startup state restoration that is excluded by default:

```sh
./benchmark/run.sh --shada shada-current
```

For a reproducible test across machines or when debugging a particular state file, use a copied ShaDa file explicitly:

```sh
./benchmark/run.sh --shada-file ~/debug/main.shada shada-debug
```

`--shada-file` requires an existing regular file and passes it directly as Neovim's `-i` argument. Keep it unchanged between snapshots; otherwise the comparison includes changed ShaDa contents. The runner sets `shadafile=NONE` after startup and before quitting, so repeated measurements read the selected ShaDa state but do not rewrite it. ShaDa benchmarks still use `-n`, so swap-file I/O remains excluded.

## Persistent-undo example

Persistent undo must be set before the target buffer opens, so compare two configuration snapshots: run once with `undofile` disabled and once with it enabled. For large files, the config's `BufReadPre` big-file guard should keep the configured result stable.
