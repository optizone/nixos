#!/usr/bin/env bash

TMPFILE=$(mktemp)
CMD="[float; center 1; size monitor_w*0.5 monitor_h*0.5] echo \$$ > $TMPFILE; exec kitty -e yazi --chooser-file='$1'"
hyprctl -q dispatch exec "$CMD"
sleep 1
waitpid "$(cat $TMPFILE)" 2>/dev/null
rm "$TMPFILE"
