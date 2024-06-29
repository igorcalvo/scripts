sh ~/code/scripts/cs-out.sh

picom &

sxhkd &

# unclutter - mouse?

dunst &

# polybar &
for m in $(polybar --list-monitors | cut -d":" -f1); do
    MONITOR=$m polybar &
    # MONITOR=$m polybar --reload example &
done
      
# nitrogen ~/images/wallpapers/2024-06/pc/wallpaper5.png --set-auto
nitrogen --restore &

bspwm
