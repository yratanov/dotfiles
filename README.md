Installation common
=============

Font: https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip

ZSH:
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

Installation Tools on MacOS
==================

```
brew install alacritty neovim stow fzf rbenv ruby-build tmux tmuxinator gh koekeishiya/formulae/skhd
skhd --start-service
```

Installing configs
=====================
stow 2.4.1 required


```
stow --dotfiles --target=$HOME .
```

