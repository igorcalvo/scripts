kill -9 $(pgrep anki | head -n1)
kill -9 $(pgrep AppRun.wrapped | head -n1)

cat ~/code/scripts/key-bindings.ahk | sed "s/; N/N/;w /home/calvo/code/scripts/key-bindings.ahk"

screen -d -m ahk_x11 ~/code/scripts/key-bindings.ahk
anki &

notify-send "NUMPAD" "Remapping 2 and 3"
