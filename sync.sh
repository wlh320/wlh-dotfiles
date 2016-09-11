#!/bin/sh
echo "Step 1 : Copy dotfiles"
git clone https://github.com/wlh320/wlh-dotfiles.git ~/wlh-dotfiles

#vimrc
mv .vimrc .vimrc.bak
ln -s ~/wlh-dotfiles/vimrc ~/.vimrc

#need oh-my-zsh
mv .zshrc .zshrc.bak
ln -s ~/wlh-dotfiles/zshrc ~/.zshrc
cp ~/wlh-dotfiles/myspaceship.zsh-theme ~/.oh-my-zsh/custom/themes

#vimperator (In fact I no longer use firefox)
ln -s ~/wlh-dotfiles/vimperator ~/.vimperator
ln -s ~/wlh-dotfiles/vimperator/.vimperatorrc ~/.vimperatorrc

#i3
ln -s ~/wlh-dotfiles/i3 ~/.i3
# rofi need this
ln -s ~/wlh-dotfiles/Xresources ~/.Xresources

echo "Enjoy it!"
