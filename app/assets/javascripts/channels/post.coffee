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

    $(document).on 'click', '[data-behavior~=room_speaker]', ->
      input = $('#btn-input')
      if input.val() != ''
        player_id = input.data('player_id')
        App.post.speak(input.val(), player_id)
        input.val('')
