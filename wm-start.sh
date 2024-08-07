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
nitrogen --restore &

unclutter --timeout 3 --jitter 5 --start-hidden &
xinput --set-prop 8 'libinput Accel Profile Enabled' 0, 1
xinput --set-prop 8 'libinput Accel Speed' -0.333
xrdb ~/.Xresources
xsetroot -cursor_name left_ptr
screen -d -m polychromatic-tray-applet

# xmodmap -e "remove mod4 = Super_L"
# xmodmap -e "add control = Super_L"
setxkbmap -option caps:super
numlockx &
ahk_x11 ~/code/scripts/key-bindings.ahk &
clipcatd

screen -d -m sh ~/code/scripts/startup.sh
bspwm
