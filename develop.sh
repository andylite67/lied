lsc -wc app.ls &
lsc -wc client.ls &
compass2.0 watch static/ &
sudo supervisor app.js
