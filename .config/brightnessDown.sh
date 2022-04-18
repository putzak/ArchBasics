#!/bin/zsh

# Brightness control script

MON="DP-2"
BRT=$( xrandr --verbose --current | grep ^"$MON" -A5 | tail -n1 )
BRTS="${BRT##* }"
let "NBRT=BRTS-0.1"
xrandr --output DP-2 --brightness $NBRT

echo "Brightness is now set at $NBRT"
