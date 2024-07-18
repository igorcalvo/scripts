cat ~/code/scripts/key-bindings.ahk | sed -z "s/\nNumpad/\n;Numpad/g;w ~/code/scripts/key-bindings.ahk"
notify-send "NUMPAD" "Restored"
