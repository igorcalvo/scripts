sleep 0.25
hyprctl dispatch workspace 1;
sleep 0.125
screen -d -m librewolf --new-tab --url moz-extension://75a0cd2e-e8e3-4f74-8a2e-186cec1622ac/index.html

sleep 1.5
hyprctl dispatch workspace 7;
sleep 0.25
screen -d -m kitty btop
sleep 0.25
screen -d -m kitty cava
sleep 0.25
screen -d -m youtube-music

sleep 4.0
hyprctl dispatch workspace 2;
sleep 0.25
playerctl play-pause

