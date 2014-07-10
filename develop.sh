sudo killall supervisor
sudo killall node
sudo killall lsc
sudo killall compass2.0
sudo supervisor app.js &
sleep 10
lsc -wc app.ls &
lsc -wc client.ls &
compass2.0 watch static/ &
