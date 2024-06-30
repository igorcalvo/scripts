#!/usr/bin/env bash

# example: ./font_find.sh 🎩︎

# credits: David Baynard, https://unix.stackexchange.com/a/393740/14907

param="$1"
char=${param:0:1}
printf '%x' \'"$char" | xargs -I{} fc-list ":charset={}"
