socket = io.connect()
_ = require 'prelude-ls'

var song
var song_pos
var song_name
text_type = "text.txt"

# events to listens
socket.on 'new_pos', (data) ->
	showSongPart data

socket.on 'new_song', (data) ->
	loadSong data

# common song show system
loadSong = (name) ->
	song_name := name
	$.get '/songs/'+name+'/'+text_type, (text) ->
		song := parseSongText text
		showSongPart 0

showSongPart = (pos) ->
	/*if song.length < (pos - 1)
		$ '#song_area' .empty!
		return */
	song_pos := pos
	$ '#song_area' .empty!
	$ '#song_area' .append "<span>" + (_.at pos, song) + "</span>" #span because of textfill
	$ '#song_area' .textfill!

parseSongText = (text) ->
	verse = _.split '\n\n\n' text
	_.flatten _.map (_.split '\n\n'), verse

#show admin song select
initSongSelect = ->
	#$ '#select_area' .show!
	$.get '/list_songs', (resp) ->
		liSong = (item) ->
			"<li value=><a href='' id='"+(_.first item)+"'>"+(_.last item) + "</a></li>"
		lis = _.map liSong, (_.obj-to-pairs resp)
		con =  _.fold (+), "", lis
		$ '#search_list'  .append con
		$ '#search_input' .fastLiveFilter '#search_list', {maxFontSize: 70}

		$ 'a' .click  (event) ->
			event.preventDefault()
			songName = event.target.id
			socket.emit 'next_song', songName

	move = (count) ->
		socket.emit 'next_pos', song_pos + count

	$$ '#song_area'  .tap ->
		move (1)
	$$ '#song_area' .swipeLeft ->
		move (-1)
	$$ '#song_area' .swipeRight ->
		move (1)

	$ '#song_area' .keydown (ev) ->
		if ev.which == 39
			move (1)
			ev.preventDefault()

initSongRecommend = ->
	$.get '/list_songs', (resp) ->
		liSong = (item) ->
			"<li value=>"+(_.last item) + "</li>"
		lis = _.map liSong, (_.obj-to-pairs resp)
		con =  _.fold (+), "", lis
		$ '#search_list'  .append con
		$ '#search_input' .fastLiveFilter '#search_list', {maxFontSize: 70}

# load admin view
if window.location.hash.substring(1) == "admin"
	initSongSelect!
else
	initSongRecommend!

$ '#text_type button' .click ->
	text_type := $ this .val!
	my_song_pos = ^^song_pos#todo: does not work
	loadSong song_name
	showSongPart my_song_pos

	$ '#text_type button' .removeClass 'active'
	$ this .addClass 'active'
