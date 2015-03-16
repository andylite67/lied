socket = io.connect()
_ = require 'prelude-ls'

var song 
var song_pos 
var song_name
var suggested
var all_songs

isAdmin = -> window.location.hash.substring(1) == "admin"


default_text_type = "text" 
text_type = default_text_type

# events to listens
socket.on 'new_pos', (data) ->
  if data[0] != song_name
    loadSong data[0], data[1]
  else
    showSongPart data[1]


loadSong = (name, pos) ->
  console.log('loadSong ' + name + ' at ' +pos)  
  pos = pos || 0
  song_name := name
  res = $.get '/songs/' + name + '/' + text_type+".txt", (text) ->
    $ '#song_title' .html all_songs[name]
    song := parseSongText text
    showSongPart pos
  res.fail -> 
    if text_type != default_text_type
      changeTextType default_text_type
      loadSong name, pos
        
showSongPart = (pos) ->
  console.log 'showSongPart: ' + pos
  if typeof song == "undefined" || pos >= song.length || pos < 0
    $ '#song_pos' .html ""
  else
    if(pos == 0) 
      $ '#button_prev' .addClass('disabled')
    else
      $ '#button_prev' .removeClass('disabled')
    if(pos < song.length - 1) 
      $ '#button_next' .removeClass('disabled')
    else
      $ '#button_next' .addClass('disabled')
      
    $ '#song_pos' .html " " + (pos+1) + " / " + song.length
    song_pos := pos
    console.log "song" + song
    showText (_.at pos, song)

showText = (text) ->
  $ '#song_area' .empty!
  $ '#song_area' .append "<span>" + text.trim! + "</span>" #span because of textfill
  $ '#song_area' .textfill!

parseSongText = (x) -> _.split '\n\n' x

#list songs with data
list_songs = (resp) ->
  liSong = (item) ->
      "<li value=><a href='#' id='"+(_.first item)+"'>"+(_.last item) + "</a></li>"
  all_songs := resp    
  lis = _.map liSong, (_.obj-to-pairs all_songs)
  lis = _.sort lis
  con =  _.fold (+), "", lis
  $ '#search_list'  .append con
  $ '#search_input' .fastLiveFilter '#search_list', {maxFontSize: 70}
  $ 'a' .click  (event) ->
    event.preventDefault()
    songName = event.target.id
    emitSong songName, 0
    loadSong songName, 0
    $ "html, body" .animate {scrollTop: 0}, "fast"

#show admin song select
initSongSelect = ->
  $.get '/list_songs', list_songs
  suggested := ['asd']

  move = (count) ->
    emitSong song_name, song_pos+count
    showSongPart (song_pos+count)

  $$ '#song_area'  .tap ->
    move (1)
  $$ '#song_area' .swipeRight ->
    move (-1)
  $$ '#song_area' .swipeLeft ->
    move (1)
    
  $ '#button_prev' .click ->
    move (-1)
  $ '#button_next' .click ->
    move (1)
    
  $ 'body' .keydown (ev) ->
    if ev.target.id != 'search_input'
      if ev.which == 39
        move (1)
        ev.preventDefault()
      else if ev.which == 37
        move (-1)
        ev.preventDefault()
    
  # show suggestions
  socket.on 'suggested_song', (data) ->
    console.log "suggestested " + song
    songLink = $ ('a#'+data)
    songLink .append "☆"

emitSong = (song, pos) ->
  console.log(isAdmin!)
  if isAdmin!
    socket.emit 'next_pos', [song, pos]
  else
    console.log(suggested)
    if ($ .inArray song, suggested) >= 0
      console.log("already suggested " + song)
    else
      suggested.push(song)
      socket.emit 'suggest_song', song
      console.log "suggest " + song
# load admin view
initSongSelect!

$ window .load ->
  showText 'Lasst uns singen dem HERRN zur Ehre!<br />
  <br />
  Das Wort des des Christus wohne reichlich in euch; <br />
  in aller Weisheit lehrt und ermahnt euch gegenseitig!<br />
  Mit Psalmen, Lobliedern und geistlichen Lieder <br />
  sing Gott in euren Herzen in Gnade (Kol 3:16)'

changeTextType = (newType) ->
  text_type := newType
  $ '#text_type button' .removeClass 'active'
  $ ('#text_type_' + newType) .addClass 'active'
   
$ '#text_type button' .click ->
  changeTextType ($ this .val!)
  loadSong song_name, song_pos
