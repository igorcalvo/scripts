pkill -TERM anki
pkill -TERM AppRun.wrapped

cat ~/code/scripts/key-bindings.ahk | sed -z "s/\nNumpad/\n; Numpad/g;w /home/calvo/code/scripts/key-bindings.ahk"
screen -d -m ahk_x11 ~/code/scripts/key-bindings.ahk

notify-send "NUMPAD" "Restored" --icon=text-html --app-name="Keyboard" -t 500

bspc desktop -f 'L2'
sleep 0.250
xdotool key Ctrl+w
sleep 0.125
xdotool key Ctrl+w
sleep 0.125
xdotool key Ctrl+w
