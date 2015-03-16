exp = require 'express.io'
app = exp()
app.http().io()

app.io.route 'next_pos',  (req) ->
  console.log req.data

app.io.route 'suggest_song', (req) ->
  console.log req.data

app.get '/client.js', (req_,res) ->
  res.sendfile __dirname + '/client.js'

app.get '/', (req,res) ->
  res.sendfile __dirname + '/client.html'

app.get '/list_songs', (req,res) ->
  res.sendfile __dirname + '/songs/database.json'

app.use '/static', exp.static __dirname + '/static'
app.use '/songs', exp.static __dirname + '/songs'

console.log 'App running on port 7777'
app.listen 7777
