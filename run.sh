lsc -wc app.ls &
lsc -wc client.ls &
compass watch static/ &
supervisor app.js
