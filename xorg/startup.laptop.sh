xset -dpms
# prevents screens from sleeping
#
sleep 1
bspc desktop -f 'L3'

sleep 0.250
screen -d -m wezterm start -- ~/code/scripts/tasks.sh

sleep 1
bspc desktop -f 'C1'
wezterm

sleep 0.250
bspc node -c
