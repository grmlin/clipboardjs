do ->
  dropDown = null

  isSubscribed = ->
    userId = Session.get SESSION_USER
    streamShortId = Session.get SESSION_SHORT_STREAM_ID

    Streams.find({short_id: streamShortId, users: userId}).count() > 0

  reactiveList = () ->
    Meteor.renderList(
      Messages.find({stream_id: Session.get(SESSION_SHORT_STREAM_ID)})
    , (message) ->
      return Template.stream_list_item message
    , ->
      return Template.stream_list_empty()
    )

  addMessage = () ->
    text = document.getElementById("stream-message")
      
    if text.value.replace(" ","").replace(/(\r\n|\n|\r)/gm,"") isnt ""
      messagesController.createStreamMessage(text.value, dropDown?.getLang(), Session.get(SESSION_SHORT_STREAM_ID))
      text.value = ""
      
  Template.stream.helpers
    show: ->
      streamId = Session.get(SESSION_SHORT_STREAM_ID)
      isRightState = appState.getState() is appState.STREAM

      isRightState and streamId isnt ""

    is_owner: ->
      streamId = Session.get(SESSION_SHORT_STREAM_ID)
      userId = Session.get(SESSION_USER)
      Streams.findOne({short_id: streamId}).owner is userId

    is_subscribed: ->
      isSubscribed()

  Template.stream.rendered = ->
    if isSubscribed()
      list = this.find(".stream-list ul")
      document.getElementById("stream-list")?.appendChild reactiveList()
      dropDown = new LangDropdown($(this.find('.language-toggle')))

  Template.stream.events =
    'click .paste': (evt) ->
      addMessage()

    "keypress #stream-message": (evt) ->
      keycode = if event.which then event.which else event.keyCode
      if keycode is 10 or (keycode is 13 and evt.ctrlKey)
        addMessage()

    'click .remove': (evt) ->
      messagesController.leaveStream(Session.get(SESSION_SHORT_STREAM_ID))

    'click .delete': (evt) ->
      messagesController.deleteStream(Session.get(SESSION_SHORT_STREAM_ID))

    "blur #stream-message": (evt) ->
      Mousetrap.unbind "ctrl+return"
    
      
