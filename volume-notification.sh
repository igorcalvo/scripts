vol_value=$(pactl get-sink-volume $(pactl get-default-sink) | awk -F '/' '/1/ {print $2}' | sed 's/ //g' | sed 's/%//')
notify-send " $vol_value %" "" -t 250 --icon=audio-headphones --app-name="Volume"
