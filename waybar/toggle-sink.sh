available_sinks=$(wpctl status | awk '/Sinks:/, /^[[:space:]]*$/ { print $2 $3 }' | awk 'NR==2 || NR==3' | sed "s/\*//" | sed 's/\.[^.]*$/./' | sed "s/\.//")
default_sink_id=$(wpctl status | awk '/\*/ { sub(/\./, "", $3); print $3 }' | head -n 1)

for id in $available_sinks; do
    if [[ "$id" != "$default_sink_id" ]]; then
        the_other_sink=$id
        break
    fi
done

# echo $available_sinks
# echo "\n"
# echo $default_sink_id
# echo "\n"
# echo $the_other_sink

wpctl set-default "$the_other_sink"
