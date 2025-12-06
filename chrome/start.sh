#!/bin/bash

Xvfb :0 -screen 0 1920x1080x24 &

export DISPLAY=:0

#--kiosk https://selfedits.dev.internetservicesltd.co.uk/selfedits

fluxbox &

google-chrome \
  --no-sandbox \
  --disable-dev-shm-usage \
  --disable-gpu \
  --disable-software-rasterizer \
  --disable-extensions \
  --no-first-run \
  --disable-session-crashed-bubble &




x11vnc -display :0 -nopw -forever -shared &


exec websockify --web=/opt/novnc 6080 localhost:5900



