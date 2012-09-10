BoardsRouter = Backbone.Router.extend
  routes:
    "list": "list"
    "message/": "list"
    "message/:message_id": "message"
    "stream/": "list"
    "stream/:stream_id": "stream"
    
  initialize: ->
    $ =>
      $("body").on "click", ".internal-link", (evt) =>
        evt.preventDefault()
        @navigate evt.currentTarget.getAttribute("href"), trigger: true
    
  _closeRawFileDialog: ->
    $('.raw-file .close').click()
    
  list: ->
    @_closeRawFileDialog()
    appState.setState appState.LIST
    messagesController.resetMessageSession()
    messagesController.resetStreamSession()

  message: (message_id) ->
    @_closeRawFileDialog()
    console.log "loading message #{message_id}"
    appState.setState appState.MESSAGE
    messagesController.resetStreamSession()
    Session.set SESSION_SHORT_MESSAGE_ID, message_id
  
  stream: (stream_id) ->
    @_closeRawFileDialog()
    console.log "loading stream #{stream_id}"
    appState.setState appState.STREAM
    messagesController.resetMessageSession()

    Session.set SESSION_SHORT_STREAM_ID, stream_id