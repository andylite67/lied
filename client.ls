socket = io.connect()
_ = require 'prelude-ls'

var song
var song_pos
var song_name

isAdmin = window.location.hash.substring(1) == "admin"

text_type = "text.txt"

# events to listens
socket.on 'new_pos', (data) ->
	if data[0] != song_name
		loadSong data[0], data[1]
	else
		showSongPart data[1]


loadSong = (name, pos) ->
	pos = pos || 0
	song_name := name
	$.get '/songs/' + name + '/' + text_type, (text) ->
		console.log text
		song := parseSongText text
		showSongPart 0

showSongPart = (pos) ->
	console.log "showSongPart: " + pos
	/*if song.length < (pos - 1)
		$ '#song_area' .empty!
		return */
	song_pos := pos
	console.log "song" + song
	showText (_.at pos, song)

showText = (text) ->
	$ '#song_area' .empty!
	$ '#song_area' .append "<span>" + text.trim! + "</span>" #span because of textfill
	$ '#song_area' .textfill!

/*parseSongText = (_.split '\n\n\n' _) |> (_.map (_.split '\n\n')) |> _.flatten*/
parseSongText = (x) -> _.split '\n\n' x

#show admin song select
initSongSelect = ->
	#$ '#select_area' .show!
	$.get '/list_songs', (resp) ->
		liSong = (item) ->
			"<li value=><a href='#' id='"+(_.first item)+"'>"+(_.last item) + "</a></li>"
		lis = _.map liSong, (_.obj-to-pairs resp)
		con =  _.fold (+), "", lis
		$ '#search_list'  .append con
		$ '#search_input' .fastLiveFilter '#search_list', {maxFontSize: 70}

		$ 'a' .click  (event) ->
			event.preventDefault()
			songName = event.target.id
			emitSong songName, 0
			loadSong songName, 0
			$ "html, body" .animate {scrollTop: 0}, "fast"

	move = (count) ->
		emitSong song_name, song_pos+count
		showSongPart (song_pos+count)

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

	# show suggestions
	socket.on 'suggested_song', (data) ->
		songLink = $ ('a#'+data)
		songLink .append "☆"

emitSong = (song, pos) ->
	if isAdmin
		socket.emit 'next_pos', [song, pos]

# load admin view
initSongSelect!

$ window .load ->
	showText "Lasst uns singen dem HERRN zur Ehre!<br />
	<br />
	Das Wort des des Christus wohne reichlich in euch; <br />
	in aller Weisheit lehrt und ermahnt euch gegenseitig!<br />
	Mit Psalmen, Lobliedern und geistlichen Lieder <br />
	sing Gott in euren Herzen in Gnade (Kol 3:16)"

$ '#text_type button' .click ->
	text_type := $ this .val!
	my_song_pos = ^^song_pos#todo: does not work
	loadSong song_name
	showSongPart my_song_pos

	$ '#text_type button' .removeClass 'active'
	$ this .addClass 'active'
