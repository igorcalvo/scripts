; #l::Msgbox, test
^!f::Run, bash -ic "sh /home/calvo/code/scripts/cs_kill.sh"
^!g::Run, bash -ic "sh /home/calvo/code/scripts/cs_in.sh"
^!h::Run, bash -ic "sh /home/calvo/code/scripts/cs_out.sh"

#e::Run, bash -ic "xdg-open ."
+#s::Run, bash -ic "flameshot gui"
^!t::Run, bash -ic "sh /home/calvo/code/scripts/terminal.sh"
^!n::Run, bash -ic "sh /home/calvo/code/scripts/neovim.sh"

PrintScreen::Run, bash -ic "flameshot full -p ~/images/screenshots"
#l::Run, bash -ic "gnome-screensaver-command -l"
^ScrollLock::Run, bash -ic "systemctl reboot"
CtrlBreak::Run, bash -ic "sh /home/calvo/code/scripts/shutdown.sh"
; ^!PrintScreen::Run, bash -ic "systemctl reboot"
; ^PrintScreen::Run, bash -ic "sh /home/calvo/code/scripts/shutdown.sh"

; +Ins::Run, bash -ic "xdotool key --clearmodifiers ctrl+shift+v"

^NumpadDiv::Send gj
; ^z::Send u
; ^+z::Send {Ctrl down}{r}{Ctrl up}

