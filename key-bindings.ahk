; #l::Msgbox, test
^!f::Run, bash -ic "sh /home/calvo/code/scripts/cs-kill.sh"
^!g::Run, bash -ic "sh /home/calvo/code/scripts/cs-in.sh"
^!h::Run, bash -ic "sh /home/calvo/code/scripts/cs-out.sh"

#e::Run, bash -ic "xdg-open ."
+#s::Run, bash -ic "flameshot gui"
^!t::Run, bash -ic "sh /home/calvo/code/scripts/terminal.sh"
^!n::Run, bash -ic "sh /home/calvo/code/scripts/neovim.sh"

PrintScreen::Run, bash -ic "flameshot full -p ~/images/screenshots"
#l::Run, bash -ic "gnome-screensaver-command -l"
^ScrollLock::Run, bash -ic "systemctl reboot"
^Pause::Run, bash -ic "sh /home/calvo/code/scripts/shutdown.sh"
; ^!PrintScreen::Run, bash -ic "systemctl reboot"
; ^PrintScreen::Run, bash -ic "sh /home/calvo/code/scripts/shutdown.sh"

^NumpadDiv::Send gj
; +Ins::Run, bash -ic "xdotool key --clearmodifiers ctrl+shift+v"
; ^z::Send u
; ^+z::Send {Ctrl down}{r}{Ctrl up}

