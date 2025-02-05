source ~/.bashrc
sh ~/code/scripts/screen-laptop.sh

picom &
sxhkd &
dunst &
polybar &
# for m in $(polybar --list-monitors | cut -d":" -f1); do
    # MONITOR=$m polybar &
    # MONITOR=$m polybar --reload example &
# done
nitrogen --restore &
# needed for VM
lxqt-policykit-agent &

unclutter --timeout 3 --jitter 5 --start-hidden &
sh ~/code/scripts/reset-mouse.laptop.sh
# sources cursor
xrdb ~/.Xresources
xsetroot -cursor_name left_ptr

screen -d -m polychromatic-tray-applet

# xmodmap -e "remove mod4 = Super_L"
# xmodmap -e "add control = Super_L"
# setxkbmap -option caps:super
numlockx &
ahk_x11 ~/code/scripts/key-bindings.ahk &
clipcatd

screen -d -m sh ~/code/scripts/startup.laptop.sh
bspwm
