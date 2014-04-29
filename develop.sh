lsc -wc app.ls &
lsc -wc client.ls &
compass watch static/ &
sudo supervisor app.js
