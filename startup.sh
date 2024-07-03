sleep 3

screen -d -m tilix
screen -d -m steam -silent
screen -d -m youtube-music
screen -d -m discord --start-minimized
screen -d -m python ~/code/scripts/hourly.py

# youtube-music
sleep 2 # 1 sec
playerctl play-pause
