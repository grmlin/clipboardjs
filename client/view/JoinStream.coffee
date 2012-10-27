Template.join_stream.helpers
  show: ->
    if appState.getState() is appState.STREAM_JOIN
      streamId = Session.get(SESSION_SHORT_STREAM_ID_JOINING)
      if streamController.isSubscribed(streamId, Meteor.userId())
        boardsRouter.navigate "/stream/#{streamId}", trigger: true
        return false
      else
        return yes
        
    else 
      return false

Template.join_stream.events =
  'click .join-stream .join': (evt) ->
    messagesController.joinStream(Session.get(SESSION_SHORT_STREAM_ID_JOINING))

  'click .join-stream .login-proxy': (evt) ->
    document.querySelector('#login-buttons .login-link-text').click()
