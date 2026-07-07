#!/bin/sh

sketchybar --add item weather right \
  --set weather \
  icon=󰖐 \
  script="$PLUGIN_DIR/weather.sh" \
  update_freq=1500 \
  --subscribe weather mouse.clicked

sketchybar --add item weather-popup right \
  --set weather-popup \
  script="$PLUGIN_DIR/weather-popup.sh" \
  update_freq=1500 \
  --subscribe weather-popup mouse.clicked
