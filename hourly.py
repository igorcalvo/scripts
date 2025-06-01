import datetime
import time
import os
import sys

one_hour = 3600
day_command = "hyprctl hyprsunset identity"
nt1_command = "hyprctl hyprsunset temperature 5000"
nt2_command = "hyprctl hyprsunset temperature 4000"

late_at_night = True

def cs2_is_running() -> bool:
    cmd = os.popen("pgrep cs2")
    res = cmd.read()
    return len(res) > 1

while True:
    hour = datetime.datetime.now().hour

    if hour < 18 and not hour < 7:
        os.system(day_command)

    if hour >= 18 and not cs2_is_running():
        os.system(nt1_command)

    if hour < 6 and late_at_night and not cs2_is_running():
        late_at_night = False
        os.system(nt2_command)
    
    time.sleep(one_hour)
