# BASH

## Custom Prompt

The default prompt uses two lines, with a bold blue directory and the terminal's
default foreground and background, matching the minimal tmux theme:

```text
~/.dotfiles (main)
$
```

A prompt hook prints a newline after the previous command's output. Ctrl-L
redraws the prompt at the top of the screen without that separator.

Version control details and an active Python or Conda environment appear beside
the directory. Jujutsu repositories show `jj:[@ change-id commit-id bookmarks]`,
plus `conflict` when applicable, based on the
[Jujutsu wiki example](https://github.com/jj-vcs/jj/wiki/Shell-Prompt).
The Jujutsu component uses `--ignore-working-copy` so rendering never snapshots
the workspace; it reflects the last recorded state. Git repositories keep their
branch and dirty/upstream state. In colocated repositories, Jujutsu takes precedence.

The prompt updates on every command. Over SSH, `user@host`
appears before the directory. A failed command adds its exit code in yellow before
`$` on the second line; root uses `#` instead. Terminals without color support get
the same layout in plain text.

The prompt is loaded automatically from `config/ps1rc.bash`. After updating, run
`source ~/.bashrc` in Bash (or use `bashreload`) to apply it. Environment activation
uses this prompt's environment indicator rather than adding a separate prefix.

## Bash Best Practices

Guide [here](http://mywiki.wooledge.org/BashGuide/Practices#Bash_Tests)
