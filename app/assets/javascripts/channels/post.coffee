jQuery(document).on 'turbolinks:load', ->
  messages = $('#message-list')
  if messages.length > 0
    App.post = App.cable.subscriptions.create {channel: "PostChannel", room_id: messages.data('room_id')},
      connected: ->
        # Called when the subscription is ready for use on the server

      disconnected: ->
        # Called when the subscription has been terminated by the server

      received: (data) ->
        $('#message-list').append data['message']

      speak: (message, player_id) ->
        @perform('speak', {message: message, player_id: player_id})

    $(document).on 'keypress', '[data-behavior~=room_speaker]', (event) ->
      if event.keyCode is 13 # return = send
        player_id = $('#btn-input').data('player_id')
        App.post.speak(event.target.value, player_id)
        event.target.value = ''
        event.preventDefault()
