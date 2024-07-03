import datetime
import time
import os
import sys

one_hour = 3600
script_path = "~/.config/polybar/nightlight.sh"

first_run = True
late_at_night = True

while True:
    hour = datetime.datetime.now().hour

    if hour < 18:
        os.system(f"sh {script_path} -")
        time.sleep(1)
        os.system(f"sh {script_path} -")

    if hour >= 18 and first_run:
        first_run = False
        os.system(f"sh {script_path} +")

    if hour < 6 and late_at_night:
        late_at_night = False
        os.system(f"sh {script_path} +")
    
    time.sleep(one_hour)
