# ZSH

## Installation

To change your default shell to zsh use

```bash
chsh -s "$(which zsh)"
```

## Configuration

### Plugins

- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting.git)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions.git)
- [zsh-vi-mode](https://github.com/jeffreytse/zsh-vi-mode.git)

### Prompt

The native prompt uses two left-aligned lines with no right prompt:

```text
~/src/project  jj:[@ change-id commit-id bookmarks]  [environment]
% 
```

The full directory uses Zsh's `%~` expansion (including named directories) in
regular-weight blue. Repository and environment text use the terminal foreground.
Conda takes precedence over a Python virtual environment; both update on each
prompt. Over SSH or as root, `user@host` precedes the directory. Root uses `#`.
A failed command adds its numeric exit code in yellow on the second line:

```text
~/src/project  git:[main+*]
1 % 
```

Jujutsu shows the change ID, commit ID, bookmarks, and `conflict` when present.
It reads the last recorded state with `--ignore-working-copy`, without taking
a snapshot or creating an operation. Edits appear after the next normal Jujutsu
command records them. Jujutsu wins in colocated repositories; a nested Git
repository shows its own Git status. Git uses Zsh's built-in `vcs_info`: `+` means
staged changes and `*` means unstaged tracked changes. There are no upstream
counts. Missing or failing Jujutsu commands quietly omit the repository segment.

There are no prompt dependencies. Terminals without at least eight colors get
plain text. Long paths wrap naturally. A prompt hook prints a newline after the
previous command's output. Ctrl-L redraws the prompt at the top of the screen
without that separator.
Repository and environment names have literal percent signs escaped and control
characters rejected; prompt command substitution and bang expansion are disabled.

### Migrating from Powerlevel10k

After updating the configuration, start a fresh shell with `exec zsh` to clear
Powerlevel10k's existing hooks. Its theme, instant prompt, generated configuration,
and installer entry are no longer used. Existing downloaded plugins and caches
can stay on disk.

Syntax highlighting, autosuggestions, vi-mode cursor behavior, fzf integration,
completions, keybindings, and automatic directory listings remain configured.
Local overrides in `$LOCAL_CONFIG/zshrc` still load last. Bash also uses a prompt
hook to separate its prompt from command output. Tmux is unchanged.

## References

- [Configuring ZSH completion with zstyle](https://thevaluable.dev/zsh-completion-guide-examples/)
- [ZSH Bench - benchmarking ZSH configurations](https://github.com/romkatv/zsh-bench)
  - [Fast and simple ZSH configuration file](https://github.com/romkatv/zsh-bench/blob/master/configs/diy%2B%2B/skel/.zshrc)
