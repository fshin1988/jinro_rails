jQuery(document).on 'turbolinks:load', ->
  messages = $('#message-list')
  if messages.length > 0
    App.post = App.cable.subscriptions.create {channel: "PostChannel", room_id: messages.data('room_id'), player_id: messages.data('player_id')},
      connected: ->
        # Called when the subscription is ready for use on the server

      disconnected: ->
        # Called when the subscription has been terminated by the server

      received: (data) ->
        $('#message-list').append data['message']

      speak: (message) ->
        @perform('speak', message: message)

    $(document).on 'keypress', '[data-behavior~=room_speaker]', (event) ->
      if event.keyCode is 13 # return = send
        App.post.speak event.target.value
        event.target.value = ''
        event.preventDefault()
