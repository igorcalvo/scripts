id=$(xinput list | awk '/Razer Razer DeathAdder Essential/ && /slave  pointer/ {print $7}' | tail -n 1 | sed 's/id=//')
xinput --set-prop ${id} 'libinput Accel Profile Enabled' 0, 1
xinput --set-prop ${id} 'libinput Accel Speed' -0.5

