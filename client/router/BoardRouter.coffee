BoardsRouter = Backbone.Router.extend
  routes:
    "list": "list"
    "message/": "list"
    "message/:message_id": "message"
    
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

  message: (message_id) ->
    @_closeRawFileDialog()
    console.log "loading message #{message_id}"
    appState.setState appState.MESSAGE
    Session.set SESSION_SHORT_MESSAGE_ID, message_id