BoardsRouter = do ->
  isSubscribed = (streamShortId) ->
    userId = Meteor.userId()
    return Streams.find({short_id: streamShortId, users: userId}).count() > 0

  streamToJoin = null

  BoardsRouter = Backbone.Router.extend
    routes:
      "list": "list"
      "paste/": "redirectList"
      "paste/:message_id": "message"
      "stream/": "redirectList"
      "stream/:stream_id": "stream"
      "stream/join/": "redirectList"
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

    redirectList: ->
      this.navigate "/list", trigger: true
      
    message: (message_id) ->
      @_closeRawFileDialog()
      console.log "loading message #{message_id}"
      appState.setState appState.MESSAGE
      messagesController.resetStreamSession()
      Session.set SESSION_SHORT_MESSAGE_ID, message_id

    stream: (stream_id) ->
      @_closeRawFileDialog()
      Meteor.call("isSubscribed", stream_id, Meteor.userId(), (err, isSubscribed) =>
        if isSubscribed
          console.log "loading stream #{stream_id}"
          appState.setState appState.STREAM
          messagesController.resetMessageSession()
          Session.set SESSION_SHORT_STREAM_ID, stream_id
        else
          this.navigate "/stream/join/#{stream_id}", trigger: true
      )

    joinStream: (stream_id) ->
      # already subscribed?
      if Streams.find({short_id: stream_id, users: Meteor.userId()}).count() > 0
        this.navigate "/stream/#{stream_id}", trigger: true
        
      else  
        streamController.isStream stream_id, (isStream) =>
          if isStream
            appState.setState appState.STREAM_JOIN
  
            Session.set SESSION_SHORT_STREAM_ID_JOINING, stream_id
            messagesController.resetMessageSession()
            messagesController.resetStreamSession()
          else
            alert "This stream does not exist"
            @navigate "/list", trigger: true
