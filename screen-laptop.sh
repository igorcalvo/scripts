xrandr --output eDP-1 --auto
xrandr --output HDMI-1 --auto --primary
nvidia-settings --assign CurrentMetaMode="eDP-1: 1920x1080_120 +0+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}, HDMI-1: 1920x1080_60 +1920+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}"

