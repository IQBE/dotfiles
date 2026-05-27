#!/bin/bash
trap "killall waybar" EXIT
while inotifywait -r -e modify,create,delete,move ~/.config/waybar; do
    killall -SIGUSR2 waybar
done
