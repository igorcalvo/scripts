; #l::Msgbox, test
^!f::Run, bash -ic "sh /home/calvo/Code/Scripts/cs_kill.sh"
^!h::Run, bash -ic "sh /home/calvo/Code/Scripts/cs_in.sh"
^!g::Run, bash -ic "sh /home/calvo/Code/Scripts/cs_out.sh"

#e::Run, bash -ic "xdg-open ."
+#s::Run, bash -ic "/usr/bin/flameshot gui"
^!t::Run, bash -ic "sh /home/calvo/Code/Scripts/terminal.sh"

#l::Run, bash -ic "gnome-screensaver-command -l"
^ScrollLock::Run, bash -ic "systemctl reboot"
CtrlBreak::Run, bash -ic "sh /home/calvo/Code/Scripts/shutdown.sh"

+Ins::Run, bash -ic "xdotool key --clearmodifiers ctrl+shift+v"

^NumpadDiv::Send gj
; ^z::Send u
; ^+z::Send {Ctrl down}{r}{Ctrl up}

