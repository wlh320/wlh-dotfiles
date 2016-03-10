#!/bin/sh
if [ -d /etc/X11/xinit/xinitrc.d  ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?* ; do
        [ -x "$f"  ] && . "$f"
    done
    unset f
fi
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
xrdb ~/.Xresources &

exec openbox-session
#exec i3
