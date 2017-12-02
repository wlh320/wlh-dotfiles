#!/bin/sh
# Only for a clean home directory
# !!! warning: Don't execute when you have your own dotfiles !!!
# *** This script haven't been tested! ***

echo "Step 1 : Copy dotfiles"
git clone https://github.com/wlh320/wlh-dotfiles.git ~/dotfiles

echo "Step 2 : Install Dependencies"
sudo pacman -S zsh tmux rofi neovim python-neovim curl wget

echo "Step 3 : Link dotfiles"

# I use nvim instead of vim now

cp -r ~/dotfiles/nvim ~/.config/nvim

# install vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# install jellybeans theme:
wget https://raw.githubusercontent.com/nanotech/jellybeans.vim/master/colors/jellybeans.vim \
    -O ~/.config/nvim/colors/jellybeans.vim

# install oh-my-zsh
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# need oh-my-zsh

ln -s ~/dotfiles/zshrc ~/.zshrc
cp ~/dotfiles/myspaceship.zsh-theme ~/.oh-my-zsh/custom/themes

# vimperator byebye! - since firefox 57

# i3
ln -s ~/dotfiles/i3 ~/.i3

# rofi
ln -s ~/dotfiles/Xresources ~/.Xresources

# editorconfig
ln -s ~/dotfiles/editorconfig ~/.editorconfig

# tmux
ln -s ~/dotfiles/tmux.conf ~/.tmux.conf

echo "Done! you executed a dangerous script just now!"
