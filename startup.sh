source ~/.bashrc
sh ~/code/scripts/cs-out.sh

picom &
sxhkd &

dunst &
polybar &
# for m in $(polybar --list-monitors | cut -d":" -f1); do
    # MONITOR=$m polybar &
    # MONITOR=$m polybar --reload example &
# done

# nitrogen ~/images/wallpapers/2024-06/pc/wallpaper5.png --set-auto
nitrogen --restore &

unclutter --timeout 3 --jitter 5 --start-hidden &
xinput --set-prop 8 'libinput Accel Profile Enabled' 0, 1
xinput --set-prop 8 'libinput Accel Speed' -0.333
xrdb ~/.Xresources
xsetroot -cursor_name left_ptr

setxkbmap -option caps:super
numlockx &
ahk_x11 ~/code/scripts/key-bindings.ahk &
screen -d -m polychromatic-tray-applet
clipcatd

screen -d -m steam -silent
screen -d -m discord --start-minimized
screen -d -m youtube-music
screen -d -m python ~/code/scripts/hourly.py

# youtube-music
sleep 1 # 1 sec
playerctl play-pause

bspwm
