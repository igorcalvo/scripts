cat key-bindings.ahk | sed -z "s/\nNumpad/\n; Numpad/g;w key-bindings.ahk"
