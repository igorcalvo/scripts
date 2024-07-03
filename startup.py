import time
import os
import sys

sleep_time = 3
script_path = "~/code/scripts/startup.sh"

time.sleep(sleep_time)
os.system(f"sh {script_path}")
