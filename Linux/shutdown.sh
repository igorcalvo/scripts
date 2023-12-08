python3 /home/calvo/Code/NightlyCheck/main.py
argus_process=$(pgrep pgrep python)
wait $argus_process
systemctl poweroff
