App.post = App.cable.subscriptions.create "PostChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $('#message-list').append data['message']

  put_message: (msg) ->
    @perform('put_message', { message: msg })

$(document).on 'keypress', '[data-behavior~=room_speaker]', (event) ->
  if event.keyCode is 13 # return = send
    App.post.put_message(event.target.value)
    event.target.value = ''
    event.preventDefault()
