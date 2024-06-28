python3 /home/calvo/code/nightly_check/main.py
argus_process=$(pgrep pgrep python)
wait $argus_process
systemctl poweroff
