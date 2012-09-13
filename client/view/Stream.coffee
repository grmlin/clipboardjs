do ->
  dropDown = null
  isSubscribed = ->
    userId = Session.get SESSION_USER
    streamShortId = Session.get SESSION_SHORT_STREAM_ID

    Streams.find({short_id:streamShortId,users:userId}).count() > 0
    
  reactiveList = () -> Meteor.renderList(
    Messages.find({stream_id: Session.get(SESSION_SHORT_STREAM_ID)})
  , (message) ->
    #console.log "rerendering message", message
    return "<li>#{message.user_name}: #{message.abstract}</li>"
  , ->
    #console.log "no messages available :-("
    return '<li><div class="alert">Empty Stream</div></li>'
  )

  Template.stream.show = ->
    streamId = Session.get(SESSION_SHORT_STREAM_ID)
    isRightState = appState.getState() is appState.STREAM

    isRightState and streamId isnt "" 
  
  Template.join_stream.show = ->
    appState.getState() is appState.STREAM_JOIN
    
  Template.stream.is_subscribed = ->
    isSubscribed()
    
  Template.stream_list.show = ->
    streamId = Session.get(SESSION_SHORT_STREAM_ID)
    isRightState = appState.getState() is appState.STREAM

    isRightState and streamId isnt ""

  Template.stream.rendered = ->
    if isSubscribed()
      list = this.find(".stream-list ul")
      document.getElementById("stream-list")?.appendChild reactiveList()
      dropDown = new LangDropdown($(this.find('.language-toggle')))

  Template.stream.events =
    'click .paste': (evt) ->
      text = document.getElementById("stream-message").value
      if text isnt ""
        console.log "pasting #{dropDown?.getLang()}:#{text}"
        messagesController.createStreamMessage(text, dropDown?.getLang(), Session.get(SESSION_SHORT_STREAM_ID))

    'click .remove': (evt) ->
      messagesController.leaveStream(Session.get(SESSION_SHORT_STREAM_ID))
      
    "keypress #stream-message": (evt) ->
      keycode = if event.which then event.which else event.keyCode
      if keycode is 10 or (keycode is 13 and evt.ctrlKey)
        text = document.getElementById("stream-message").value
        if text isnt ""
          console.log "pasting #{dropDown?.getLang()}:#{text}"
          messagesController.createStreamMessage(text, dropDown?.getLang(), Session.get(SESSION_SHORT_STREAM_ID))

    "blur #stream-message": (evt) ->
      Mousetrap.unbind "ctrl+return"
    
      
  Template.join_stream.events =
    'click .join-stream button': (evt) ->
      messagesController.joinStream(Session.get(SESSION_SHORT_STREAM_ID_JOINING)) 
    
