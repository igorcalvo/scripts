# kill -9 $(pgrep anki | head -n1)

pkill AppRun.wrapped
sleep 0.250
cat ~/code/scripts/key-bindings.ahk | sed "s/; N/N/;w /home/calvo/code/scripts/key-bindings.ahk"

screen -d -m ahk_x11 ~/code/scripts/key-bindings.ahk
bspc desktop -f 'C1'
anki &

notify-send "NUMPAD" "Remapping numpad" --icon=text-html --app-name="Keyboard" -t 500

sleep 2.5
sh ~/code/scripts/japanese.sh
sleep 1.0
bspc desktop -f 'C1'

