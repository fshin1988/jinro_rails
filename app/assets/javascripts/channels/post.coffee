App.post = App.cable.subscriptions.create "PostChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $('#message-list').append data['message']

  speak: (message, room_id, player_id) ->
    @perform('speak', {message: message, room_id: room_id, player_id: player_id})

$(document).on 'keypress', '[data-behavior~=room_speaker]', (event) ->
  if event.keyCode is 13 # return = send
    room_id = $('#room_id').val()
    player_id = $('#player_id').val()
    App.post.speak(event.target.value, room_id, player_id)
    event.target.value = ''
    event.preventDefault()
