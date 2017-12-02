App.room = null

current_room_id = ->
  $('#message-list').data('room_id')

current_room_ch = ->
  id = current_room_id()
  if id?
    return {channel: 'RoomChannel', room_id: id}
  else
    return null

scroll_available = ->
  $('.chat-body').get(0).scrollHeight - $('.chat-body').outerHeight()

scroll_down = ->
  $('.chat-body').scrollTop(scroll_available())

$(document).ready ->
  if $('.chat-body').length > 0
    scroll_down()

$(document).on 'turbolinks:request-start', ->
  if current_room_ch()?
    App.room.unsubscribe()

$(document).on 'turbolinks:load', ->
  if current_room_ch()?
    App.room = App.cable.subscriptions.create current_room_ch(),
      received: (data) ->
        if data['reload']
          location.reload(true)
        else if data['message']
          scroll_position = $('.chat-body').scrollTop()
          # If the current scroll position is at the bottom, scroll down
          if scroll_position is scroll_available()
            scroll_flag = true
          else
            scroll_flag = false
          $('#message-list').append data['message']
          if scroll_flag
            scroll_down()
      speak: (message, player_id) ->
        @perform('speak', {message: message, player_id: player_id})

$(document).on 'click', '[data-behavior~=room_speaker]', ->
  input = $('#btn-input')
  if input.val() != ''
    player_id = input.data('player_id')
    App.room.speak(input.val(), player_id)
    input.val('')

$(document).on 'keydown', '#btn-input', (event) ->
  if event.shiftKey
    if event.keyCode is 13
      input = $('#btn-input')
      if input.val() != ''
        player_id = input.data('player_id')
        App.room.speak(input.val(), player_id)
        input.val('')
        event.preventDefault()
