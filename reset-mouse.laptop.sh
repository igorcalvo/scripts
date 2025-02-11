id1=$(xinput list | awk '/Razer Razer DeathAdder Essential/ && /slave  pointer/ {print $7}' | tail -n 1 | sed 's/id=//')
id2=$(xinput list | awk '/Razer Razer DeathAdder Essential/ && /slave  pointer/ {print $7}' | head -n 1 | sed 's/id=//')

xinput --set-prop ${id1} 'libinput Accel Profile Enabled' 0, 1
xinput --set-prop ${id1} 'libinput Accel Speed' -0.5

xinput --set-prop ${id2} 'libinput Accel Profile Enabled' 0, 1
xinput --set-prop ${id2} 'libinput Accel Speed' -0.5

