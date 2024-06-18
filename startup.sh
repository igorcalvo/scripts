# screen -d -m pavucontrol
screen -d -m youtube-music
screen -d -m steam -silent
screen -d -m discord
screen -d -m ahk_x11 /home/calvo/code/scripts/key-bindings.ahk
screen -d -m tilix

sleep 2
yt=$(pgrep youtube-music | head -n1)
yt=$(xdotool search --pid $yt | tail -1)
xdotool windowsize $yt 33% 100%
xdotool windowmove $yt 0 0
xdotool mousemove 1000 15
xdotool click --repeat 2 1
xdotool windowminimize $yt 

sleep 5
disc=$(xdotool search --name Friends | tail -1)
xdotool windowsize $disc 33% 100%
xdotool windowmove $disc 0 0
xdotool click --repeat 2 1
xdotool windowminimize $disc

sleep 1
tlx=$(pgrep tilix)
tlx=$(xdotool search --pid $tlx | tail -1)
xdotool windowsize $tlx 33% 100%
xdotool windowmove $tlx 3840 0
xdotool mousemove 4780 45
xdotool click --repeat 2 1

exit

