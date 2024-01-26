screen -d -m pavucontrol
# screen -d -m youtube-music
screen -d -m steam -silent
screen -d -m discord
screen -d -m autokey

sleep 2
audio_process=$(pgrep pavucontrol)
pacmd set-default-sink alsa_output.pci-0000_07_00.4.analog-stereo
xdotool windowminimize `xdotool search --pid $audio_process | tail -1`

# yt_process=$(pgrep youtube-music | head -n1)
# xdotool windowminimize `xdotool search --pid $yt_process | tail -1`

sleep 5
discord_process=$(pgrep Discord | head -n1)
xdotool windowminimize `xdotool search --pid $discord_process | tail -1`

xdotool mousemove 3000 500
xdotool click 1
xdotool windowminimize `xdotool search --pid $audio_process | tail -1`

exit
