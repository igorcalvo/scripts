;!j::Send +{;}m .1{Enter}
; #l::Msgbox, test

+Ins::Run, bash -ic "xdotool key --clearmodifiers ctrl+shift+v"
#l::Run, bash -ic "gnome-screensaver-command -l"

^NumpadDiv::Send gj
^z::Send u
^+z::Send ^r

