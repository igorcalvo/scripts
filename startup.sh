sleep 3
# screen -d -m steam -silent
screen -d -m python ~/code/scripts/hourly.py
screen -d -m tilix

bspc desktop -f 'L3'
sleep 0.250
screen -d -m wezterm start -- ~/code/scripts/tasks.sh
screen -d -m wezterm start -- python ~/code/memory/main.py

sleep 2
bspc desktop -f 'R3'
sleep 0.250
screen -d -m wezterm start -- cava
screen -d -m youtube-music
# screen -d -m discord # --start-minimized

sleep 5
playerctl play-pause
# bspc desktop -f 'R2'
# bspc node @parent -R 180

bspc desktop -f 'C1'
