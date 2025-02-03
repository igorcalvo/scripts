# must be run at ~/code/linux/dotfiles/

platform=laptop
base=/home/calvo/
paths=(
   "code/linux/dotfiles/.config/bspwm/bspwmrc"
   "code/linux/dotfiles/.config/sxhkd/sxhkdrc"
   "code/linux/dotfiles/.config/polybar/config.ini"
   "code/linux/dotfiles/.config/polybar/nightlight.sh"
   "code/linux/dotfiles/.config/dunst/dunstrc"
   "code/linux/dotfiles/.config/cava/config"
)

for i in ${paths[@]}
do
   echo "${base}${i}"
   rm "${base}${i}"
   ln -s "${base}${i}.${platform}" "${base}${i}"
   git update-index --skip-worktree "${base}${i}"
done
