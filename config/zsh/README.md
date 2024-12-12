# zsh

This folder contains all configuration files for zsh using
[zinit](https://github.com/zdharma-continuum/zinit) as the plugin manager and
[powerlevel10k](https://github.com/romkatv/powerlevel10k) as the prompt.

## Installation

Run the [install](./scripts/install_zinit) script to automatically install
zinit and all plugins.

```bash
scripts/install_zinit
```

To change your default shell to zsh use

```bash
chsh -s "$(which zsh)"
```
