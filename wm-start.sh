source ~/.bashrc
sh ~/code/scripts/cs-out.sh

picom &

sxhkd &

# unclutter - mouse?

dunst &

polybar &
# for m in $(polybar --list-monitors | cut -d":" -f1); do
    # MONITOR=$m polybar &
    # MONITOR=$m polybar --reload example &
# done

# nitrogen ~/images/wallpapers/2024-06/pc/wallpaper5.png --set-auto
nitrogen --restore &

xinput --set-prop 8 'libinput Accel Profile Enabled' 0, 1
xrdb ~/.Xresources
xsetroot -cursor_name left_ptr
numlockx &

ahk_x11 /home/calvo/code/scripts/key-bindings-wm.ahk &
screen -d -m polychromatic-tray-applet    
clipcatd

bspwm
