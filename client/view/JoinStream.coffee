Template.join_stream.helpers
  show: ->
    appState.getState() is appState.STREAM_JOIN

Template.join_stream.events =
  'click .join-stream button': (evt) ->
    messagesController.joinStream(Session.get(SESSION_SHORT_STREAM_ID_JOINING)) 