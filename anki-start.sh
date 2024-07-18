kill -9 $(pgrep anki | head -n1)
cat ~/code/scripts/key-bindings.ahk | sed "s/;N/N/;w ~/code/scripts/key-bindings.ahk"
notify-send "NUMPAD" "Remapping 2 and 3"
# anki &
