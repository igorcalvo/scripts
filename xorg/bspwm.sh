cp /usr/share/xsessions/bspwm.desktop /usr/share/xsessions/bspwm.desktop.backup
sed -i '4d' /usr/share/xsessions/bspwm.desktop
sed -i '4i Exec=sh /home/calvo/code/scripts/wm-start.laptop.sh' /usr/share/xsessions/bspwm.desktop
