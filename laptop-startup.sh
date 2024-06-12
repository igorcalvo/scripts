# screen -d -m pavucontrol
# screen -d -m youtube-music
# screen -d -m steam -silent
# screen -d -m discord
# screen -d -m autokey
screen -d -m ahk_x11 "/home/calvo/code/scripts/key-bindings.ahk"
# screen -d -m tilix

# sleep 2
# audio_process=$(pgrep pavucontrol)
# pacmd set-default-sink alsa_output.pci-0000_07_00.4.analog-stereo
# xdotool windowminimize `xdotool search --pid $audio_process | tail -1`

# yt_process=$(pgrep youtube-music | head -n1)
# xdotool windowminimize `xdotool search --pid $yt_process | tail -1`

# sleep 5
# discord_window=$(xdotool search --name Friends)
# xdotool windowminimize $discord_window

# tlx=$(pgrep tilix)
# tlx=$(xdotool search --pid $tlx | tail -1)
# sleep 1
# xdotool windowsize $tlx 33% 100%
# xdotool windowmove $tlx 3840 0
# xdotool mousemove 4780 45
# xdotool click --repeat 2 1

exit
