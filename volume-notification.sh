# correction="$1"
# correction=${correction:-0}
vol_value=$(pactl get-sink-volume $(pactl get-default-sink) | awk -F '/' '/1/ {print $2}' | sed 's/ //g' | sed 's/%//')
# vol_value=${vol_value:-0}
# vol_value=$(echo $(($vol_value+$correction)))
notify-send " $vol_value %" "" -t 300 --icon=audio-headphones --app-name="Volume"
