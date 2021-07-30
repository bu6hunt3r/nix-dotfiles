#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

outputs=$(xrandr --query | grep " connected" | cut -d" " -f1)

set -- $outputs
tray_output=$1

for m in $outputs; do
  if [ $m == $1 ]; then
    MONITOR1=$m polybar --reload top-primary &
  elif [ $m == $2 ]; then
    MONITOR2=$m polybar --reload top-secondary &
  else
    MONITOR1=$m polybar --reload top-primary &
  fi
done
