boardsRouter = new BoardsRouter()

progress = new SubscriptionProgress()
progressView = new SubscriptionProgressTemplateHelper(progress)

usersController = new UsersController()
messagesController = new MessagesController()
streamController = new StreamController()

messagePagination = new MessagesPagination()
streamsPagination = new StreamsPagination()


Meteor.startup ->
  Session.set SESSION_BOARD_ID, null

  userid = localStorage["cjs_temp_user"]
  if typeof userid is "undefined"
    userid = Meteor.uuid()
    localStorage["cjs_temp_user"] = Meteor.uuid()

  Session.set SESSION_TEMP_USER_ID, userid

  initializeApp = ->
    if Session.get(SESSION_STATE) is appState.LOADING
      appState.setState(appState.LOADED)
      Accounts.ui.config({
      passwordSignupFields: 'USERNAME_ONLY'
      })
      #observer.stop()
      Backbone.history.start({pushState: true})

      if Backbone.history.fragment is ""
        boardsRouter.navigate "/home", trigger: true

  # Subscribing 
  progress.addSubscription (subscribe) ->
    subscribe 'message_annotations', Session.get(SESSION_SHORT_MESSAGE_ID)
  
  progress.addSubscription (subscribe) ->
      subscribe 'stream_message_annotation', Session.get(SESSION_SHORT_STREAM_ID)

  progress.addSubscription (subscribe) ->
    subscribe 'invitations', usersController.getUserId()


  #observer = Meteor.users.find().observe
  # added: =>
  progress.registerInitialLoadHandler(->
    Meteor._debug "#{progress.getSubscriptionCount()} subscriptions loaded initially"
    initializeApp()
  )

