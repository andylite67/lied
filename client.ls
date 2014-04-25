
socket = io.connect()
admin = false
_ = require 'prelude-ls'
var song

$.get '/admin', (resp) ->
	if resp == true
		console.log "you are admin!"
		admin := true
		initSongSelect()

socket.on 'new_pos',(data) ->
	console.log data

socket.on 'new_song', (data) ->
	console.log data
	$.get '/songs/'+data, (data) ->
		#$ '#song_area' .append data
		song := data

initSongSelect = ->
	$.get '/list_songs', (resp) ->
		liSong = (item) ->
			"<li value=><a href='' id='"+(_.first item)+"'>"+(_.last item) + "</a></li>"
		lis = _.map liSong, (_.obj-to-pairs resp)
		con =  _.fold (+), "", lis
		$ '#search_list'  .append con
		$ '#search_input' .fastLiveFilter '#search_list'

		$ 'a' .click  (event) ->
			event.preventDefault()
			socket.emit 'next_song', event.target.id

if window.location.hash.substring(1) == "admin"
	initSongSelect()
