# zsh

This folder contains all configuration files for zsh, 
[Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh), and for
[powerlevel10k](https://github.com/romkatv/powerlevel10k).

On Ubuntu zsh can be installed with
```
sudo apt-get update
sudo apt-get install zsh
```

To change your default shell to zsh use
```
chsh -s $(which zsh)
```


[Here]() is a basic installation script which installs Oh My Zsh, the
[zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
and [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) plugins, and
[powerlevel10k](https://github.com/romkatv/powerlevel10k).

## Oh My ZSH



Alternatively, you can install run
```
sudo apt-get update
sudo apt-get install git
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```
To activate the plugins, add the plugin name to your `.zshrc` config file like
```
plugins=([... zsh-syntax-highlighting)
```

### Powerlevel10k

[powerlevel10k](https://github.com/romkatv/powerlevel10k)
is a customizable powerline theme for Oh My Zsh. The configuration file I usually use is
[here]().


## Meslo Nerd Font

Install these four fonts:
* [MesloLGS NF Regular](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf)
* [MesloLGS NF Bold](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf)
* [MesloLGS NF Italic](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf)
* [MesloLGS NF Bold Italic](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf)