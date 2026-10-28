# Dotfiles

This repository contains all the settings and configuration files for various
editors, shells, and other unix programs.

## Installation

```bash
# To install all configs
./install

# To install a specific config
./install config/alacritty/dotbot
```

### Environment variables

- `DOTBOT_OS` - Detected operating system (e.g., `linux`, `darwin`)
- `DOTBOT_FORCE` - Set to `yes` to force installation even if commands are missing
- `DOTFILES` - Path to the dotfiles directory
- `DOTFILES_HOME` - Home directory for dotfiles
- `WORKSPACE_HOME` - Custom workspace directory (default: `~/workspace`)

## Dotbot Configuration

This repository uses a custom dotbot-style installation system. The `install` script manages symlinking configuration files to their appropriate locations.

### How the Install Script Works

The `install` script accepts the following usage patterns:

```bash
# Install all configurations
./install
./install all

# Install specific configurations
./install config/alacritty/dotbot
./install config/git/dotbot config/zsh/dotbot
```

Each configuration directory (e.g., `config/alacritty/`) contains a `dotbot` file which is a bash script that performs the actual installation. The install script:

1. Sets up environment variables (`DOTBOT_OS`, `DOTFILES_HOME`, etc.)
2. Adds the local `bin/` directory to `PATH` for access to helper scripts
3. Executes each `dotbot` script in sequence
4. Reports success, failure, or skip status for each configuration

### Exit Codes

The install script and individual dotbot scripts use specific exit codes:

- **0** - Success, configuration installed
- **128** - Command not installed, configuration skipped
- **129** - Unsupported OS, configuration skipped
- **Other** - Installation failed

### Helper Scripts Used by Dotbot

Several scripts from the `bin/` directory are commonly used in dotbot files:

- `hascommand CMD` - Checks if a command exists; exits with code 128 if not found (allows graceful skipping)
- `symlinkfb SOURCE TARGET` - Creates a symlink with backup of existing target
- `cleanlinks PATH [PATH...]` - Removes dangling symlinks in specified directories

## Binaries

The `bin/` directory contains utility scripts for various purposes.

### Git Helpers

| Script | Description |
|--------|-------------|
| `git-current-branch` | Prints the name of the current git branch |
| `git-current-repo` | Prints the repository name (using origin remote when configured) |
| `git-is-repo` | Checks if the current directory is a git repository |
| `git-user-stats` | Shows commit statistics by author with insertions, deletions, and file counts |

### Fzf (Fuzzy Finder) Integrations

| Script | Description |
|--------|-------------|
| `ff` | Helper command to call fzf pickers (e.g., `ff git-branch`) |
| `fzf-docker-containers` | Interactive fuzzy finder for Docker containers with preview |
| `fzf-docker-images` | Interactive fuzzy finder for Docker images with preview |
| `fzf-docker-volumes` | Interactive fuzzy finder for Docker volumes with preview |
| `fzf-git-branch` | Interactive fuzzy finder for git branches with commit preview |
| `fzf-git-log` | Interactive fuzzy finder for git commits with diff preview |
| `fzf-git-remote` | Interactive fuzzy finder for git remotes with log preview |
| `fzf-git-stash` | Interactive fuzzy finder for git stashes with diff preview |
| `fzf-git-status` | Interactive fuzzy finder for git status with diff preview |
| `fzf-git-tag` | Interactive fuzzy finder for git tags with show preview |
| `fzf-k8s-jobs` | Interactive fuzzy finder for Kubernetes jobs with logs preview |
| `fzf-k8s-pods` | Interactive fuzzy finder for Kubernetes pods with logs preview |
| `fzf-projects` | Interactive fuzzy finder for projects in workspace with directory preview |

### Project and Directory Navigation

| Script | Description |
|--------|-------------|
| `projects` | Lists all projects in workspace (finds directories with .git, .hg, .jj, or .svg) |
| `lsgit` | Lists directories containing .git folders |
| `lsjj` | Lists directories containing .jj folders |

### Kubernetes Helpers

| Script | Description |
|--------|-------------|
| `k8s-is-valid` | Checks if kubectl is available and kube config exists |

### Color Utilities

| Script | Description |
|--------|-------------|
| `hex2ansi` | Converts RGB hex color codes to the closest terminal 256 color |
| `test-ansi-colors` | Displays all ANSI color codes (0-255) with visual representation |
| `test-24bit-colors` | Displays 24-bit color codes with rainbow gradient |

### File and Link Management

| Script | Description |
|--------|-------------|
| `cleanlinks` | Removes all dangling symlinks in given directories |
| `symlinkfb` | Force creates a symlink but backs up the target before replacing it |

### Utility Scripts

| Script | Description |
|--------|-------------|
| `hascommand` | Checks if a command exists (used by dotbot installation) |
| `nth` | Prints the nth line from stdin or a file |
| `run-script` | Executes scripts from a `scripts/` directory in the current or parent directories |
| `slice` | Prints an inclusive, one-based range of lines from a file or stdin |
