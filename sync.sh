#!/bin/sh
echo "Step 1 : Copy dotfiles"
git clone https://github.com/wlh320/wlh-dotfiles.git ~/wlh-dotfiles
ln -s ~/wlh-dotfiles/vimrc ~/.vimrc
ln -s ~/wlh-dotfiles/zshrc ~/.zshrc
ln -s ~/wlh-dotfiles/zprofile ~/.zprofile
ln -s ~/wlh-dotfiles/i3 ~/.i3
ln -s ~/wlh-dotfiles/compton ~/.compton.conf
ln -s ~/wlh-dotfiles/vimperator ~/.vimperator
ln -s ~/wlh-dotfiles/vimperator/.vimperatorrc ~/.vimperatorrc
ln -s ~/wlh-dotfiles/tint2rc ~/.config/tint2/tint2rc
ln -s ~/wlh-dotfiles/xinitrc ~/.xinitrc
#echo "Step 2 : Install vim bundle"
#git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
