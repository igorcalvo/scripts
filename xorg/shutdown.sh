# python /home/calvo/code/nightly_check/main.py
# py_process=$(pgrep -a python | grep nightly_check | awk '{print $(1)}')
# # | awk -F'[/.]' '{print $(NF-1)}'
# wait $py_process

night_light_config="~/.local/share/nightlight"
echo "ind=0" > "$night_light_config"

systemctl poweroff
