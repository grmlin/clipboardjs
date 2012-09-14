Template.stream_list.show = ->
  streamId = Session.get(SESSION_SHORT_STREAM_ID)
  isRightState = appState.getState() is appState.STREAM

  isRightState and streamId isnt ""