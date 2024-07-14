sleep 3
# screen -d -m steam -silent
screen -d -m python ~/code/scripts/hourly.py
screen -d -m tilix

bspc desktop -f 'L3'
screen -d -m wezterm start -- ~/code/scripts/tasks.sh

sleep 1
screen -d -m youtube-music
# screen -d -m discord # --start-minimized

sleep 3 
playerctl play-pause
# bspc desktop -f 'R2'
# bspc node @parent -R 180

sleep 2
bspc desktop -f 'C1'
