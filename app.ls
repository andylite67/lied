exp = require 'express.io'
app = exp()
app.http().io()


app.io.route 'next_pos',  (req) ->
	req.io.broadcast 'new_pos', req.data
	console.log 'next event' + req.data

app.io.route 'next_song', (req) ->
	req.io.broadcast 'new_song', req.data
	console.log 'new song' + req.data

app.get '/client.js', (req_,res) ->
	res.sendfile __dirname + '/client.js'

app.get '/', (req,res) ->
	res.sendfile __dirname + '/client.html'

app.get '/admin', (req,res) ->
	res.send (app.io.sockets.manager.connected === {})

app.get '/list_songs', (req,res) ->
	res.send {
		"test.txt" : "Befiel du deine Wege",
		"odietiefe.txt" : "O die Tiefe Liebe Jesu"
	}

app.use '/static', exp.static __dirname + '/static'
app.use '/songs', exp.static __dirname + '/songs'

console.log 'App running on port 80'
app.listen 80
