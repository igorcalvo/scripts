platform=pc
paths=(
   "~/code/linux/dotfiles/.config/bspwm/bspwmrc"
   "~/code/linux/dotfiles/.config/sxhkd/sxhkdrc"
   "~/code/linux/dotfiles/.config/polybar/config.ini"
   "~/code/linux/dotfiles/.config/polybar/nightlight.sh"
)

for i in "${paths[@]}"
do
    rm ${paths[$i]}
    ln -s ${paths[$i]}.${platform} ${paths[$i]}
    git update-index --skip-worktree ${paths[$i]}
done
