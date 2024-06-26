
#!/bin/bash
# Copyright (c) 2010, 2013 Yu-Jie Lin
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# Usage: termfps.sh [FRAMES] [COLUMNS] [LINES]

FRAMES=${1:-100}
COLUMNS=${2:-$(tput cols)}
LINES=${3:-$(tput lines)}
CHARS=$((COLUMNS * LINES * FRAMES))

printf -v dummy_line   "%${COLUMNS}s"     ''
printf -v dummy_line_n "%${COLUMNS}s\n"   ''
printf -v dummy_frame  "%$((LINES - 1))s" ''

for ((ch = 0; ch < 10; ch++)); do
  line_str=${dummy_line// /$ch}
  line_n_str=${dummy_line_n// /$ch}
  frame_str="${dummy_frame// /$line_n_str}$line_str"
  frame_str_r="frame_str$ch"

  eval "$frame_str_r=\"$frame_str\""
done

t_start=$(date +%s.%N)
for ((i = 0; i < FRAMES; i++)); do
  for ((ch = 0; ch < 10; ch++)); do
    frame_str="frame_str$ch"
    echo -ne "\033[H${!frame_str}"
  done
done
t_end=$(date +%s.%N)

echo
echo "For ${COLUMNS}x${LINES} $FRAMES frames."
printf "Elapsed time : %'9.3f\n" "$(bc <<< "scale=3;           ($t_end - $t_start) / 1")"
printf "Frames/second: %'9.3f\n" "$(bc <<< "scale=3; $FRAMES / ($t_end - $t_start)")"
printf "Chars /second: %'9d\n"   "$(bc <<< "scale=0; $CHARS  / ($t_end - $t_start)")"
