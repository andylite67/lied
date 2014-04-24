socket = io.connect()
admin = false

inp = $ 'input'
form = $ 'form'

console.log form

form.submit ->
	console.log 'send'
	socket.emit inp.val(), "bomb"
	return false

socket.on 'new_pos',(data) ->
	console.log data


socket.on 'new_song', (data) ->
	console.log data


