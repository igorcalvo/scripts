wezterm start --new-tab
term_process=$(pgrep wezterm-gui | head -n1)
xdotool windowfocus `xdotool search --pid $term_process`

