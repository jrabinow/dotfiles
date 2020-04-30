xrdb -merge $HOME/.Xresources
xsetroot -solid dimgray
xidle &
xterm &
setxkbmap -option ctrl:nocaps
exec dwm
