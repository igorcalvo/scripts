xrandr --output DP-2 --auto
xrandr --output DP-0 --auto --primary
xrandr --output HDMI-0 --auto
nvidia-settings --assign CurrentMetaMode="DP-2: 1920x1080_144 +0+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}, DP-0: 1920x1080_240 +1920+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}, HDMI-0: 1920x1080_75 +3840+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}"

