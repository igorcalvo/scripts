hyprctl devices | \
	awk '/active keymap: /' | \
	tail -n 1 | \
	sed "s/active keymap: English (//" | \
	sed "s/)//" | \
	sed "s/, with dead keys//" | \
	sed "s/\t\t\t//"
