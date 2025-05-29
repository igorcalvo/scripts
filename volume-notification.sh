default_sink_id=$(wpctl status | awk '/\*/ { sub(/\./, "", $3); print $3 }' | head -n 1)
vol_value=$(wpctl get-volume $default_sink_id | sed "s/Volume: 0.//")
notify-send " $vol_value %" "" -t 250 -i ~/images/icons/volume.png -u low -a volume
