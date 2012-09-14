BoardsRouter = do ->
  isSubscribed = (streamShortId) ->
    userId = Session.get SESSION_USER
    return Streams.find({short_id: streamShortId, users: userId}).count() > 0

  streamToJoin = null

  BoardsRouter = Backbone.Router.extend
    routes:
      "list": "list"
      "message/": "list"
      "message/:message_id": "message"
      "stream/": "list"
      "stream/:stream_id": "stream"
      "stream/join/:stream_id": "joinStream"

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
      Meteor.call("isSubscribed", stream_id, Session.get(SESSION_USER), (err, isSubscribed) =>
        if isSubscribed
          console.log "loading stream #{stream_id}"
          appState.setState appState.STREAM
          messagesController.resetMessageSession()
          Session.set SESSION_SHORT_STREAM_ID, stream_id
        else
          this.navigate "/stream/join/#{stream_id}", trigger: true
      )

    joinStream: (stream_id) ->
      streamController.isStream stream_id, (isStream) =>
        if isStream
          appState.setState appState.STREAM_JOIN

          Session.set SESSION_SHORT_STREAM_ID_JOINING, stream_id
          messagesController.resetMessageSession()
          messagesController.resetStreamSession()
        else
          alert "This stream does not exist"
          @navigate "/list", trigger: true
