neovide_process=$(pgrep neovide | head -n1)
xdotool windowactivate `xdotool search --pid $neovide_process`

