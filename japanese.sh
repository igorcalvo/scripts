pkill -TERM firefox
bspc desktop -f 'L2'
sleep 0.250
screen -d -m firefox "https://translate.google.com/?sl=ja&tl=en&op=translate"
sleep 0.250
firefox "https://takoboto.jp/" --new-tab
sleep 0.250
firefox "https://jisho.org/" --new-tab

