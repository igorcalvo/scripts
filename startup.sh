source ~/.bashrc
sh ~/code/scripts/cs-out.sh

picom &

sxhkd &

unclutter --timeout 5 --jitter 3 --start-hidden &

dunst &

polybar &
# for m in $(polybar --list-monitors | cut -d":" -f1); do
    # MONITOR=$m polybar &
    # MONITOR=$m polybar --reload example &
# done

# nitrogen ~/images/wallpapers/2024-06/pc/wallpaper5.png --set-auto
nitrogen --restore &

xinput --set-prop 8 'libinput Accel Profile Enabled' 0, 1
xinput --set-prop 8 'libinput Accel Speed' -0.333
xrdb ~/.Xresources
xsetroot -cursor_name left_ptr

setxkbmap -option caps:super
numlockx &

ahk_x11 /home/calvo/code/scripts/key-bindings.ahk &
screen -d -m polychromatic-tray-applet
clipcatd

screen -d -m steam -silent
screen -d -m discord --start-minimized

# screen -d -m youtube-music
# yt=$(pgrep youtube-music | head -n1)
# yt=$(xdotool search --pid $yt | tail -1)
# xdotool windowclose $yt
#
screen -d -m python hourly.py

bspwm
