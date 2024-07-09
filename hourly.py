import datetime
import time
import os
import sys

one_hour = 3600
script_path = "~/.config/polybar/nightlight.sh"

first_run = True
late_at_night = True

def cs2_is_running() -> bool:
    cmd = os.popen("pgrep cs2")
    res = cmd.read()
    return len(res) > 1

while True:
    hour = datetime.datetime.now().hour

    if hour < 18 and not hour < 7:
        os.system(f"sh {script_path} -")
        time.sleep(1)
        os.system(f"sh {script_path} -")

    if hour >= 18 and first_run and not cs2_is_running():
        first_run = False
        os.system(f"sh {script_path} +")

    if hour < 6 and late_at_night and not cs2_is_running():
        late_at_night = False
        os.system(f"sh {script_path} +")
        time.sleep(1)
        os.system(f"sh {script_path} +")
    
    time.sleep(one_hour)
