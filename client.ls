socket = io.connect()
_ = require 'prelude-ls'

var song
$ '#select_area' .hide!

socket.on 'new_pos',(data) ->
	showSongPart data

socket.on 'new_song', (data) ->
	loadSong data

loadSong = (name) ->
	$.get '/songs/'+name, (text) ->
		song := parseSongText text
		showSongPart 0

showSongPart = (pos) ->
	$ '#song_area' .empty!
	$ '#song_area' .append _.at pos, song

parseSongText = (text) ->
	verse = _.split '\n\n\n' text
	_.flatten _.map (_.split '\n\n'), verse

initSongSelect = ->
	$ '#select_area' .show!
	$.get '/list_songs', (resp) ->
		liSong = (item) ->
			"<li value=><a href='' id='"+(_.first item)+"'>"+(_.last item) + "</a></li>"
		lis = _.map liSong, (_.obj-to-pairs resp)
		con =  _.fold (+), "", lis
		$ '#search_list'  .append con
		$ '#search_input' .fastLiveFilter '#search_list'

		$ 'a' .click  (event) ->
			event.preventDefault()
			songName = event.target.id
			socket.emit 'next_song', songName
			loadSong songName

if window.location.hash.substring(1) == "admin"
	initSongSelect()


