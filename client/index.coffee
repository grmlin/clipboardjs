boardsRouter = new BoardsRouter()

progress = new SubscriptionProgress()
progressView = new SubscriptionProgressTemplateHelper(progress)

usersController = new UsersController()
messagesController = new MessagesController()
streamController = new StreamController()

loadingIndicator = new LoadingIndicator()

messagePagination = new MessagesPagination "Messages", Messages.find()


Meteor.startup ->
  Session.set SESSION_BOARD_ID, null
  Session.set SESSION_USER, null

  initializeApp = ->
    if Session.get(SESSION_STATE) is appState.LOADING
      appState.setState(appState.LOADED)
      Backbone.history.start({pushState: true})

      if Backbone.history.fragment is ""
        boardsRouter.navigate "list", trigger: true

  userid = localStorage[SESSION_USER]
  if typeof userid is "undefined"
    usersController.createUser()
  else
    usersController.loadUser(userid)

  watchUser = () ->
    update = ->
      ctx = new Meteor.deps.Context()
      ctx.on_invalidate(update)
      ctx.run ->
        userId = Session.get SESSION_USER
        unless userId is null
          console.log("The current user is now", userId);
          initializeApp()

    update()

  Meteor.autosubscribe ->
    userId = Session.get SESSION_USER
    streamId = Session.get SESSION_SHORT_STREAM_ID
    messageId = Session.get SESSION_SHORT_MESSAGE_ID

    loadingIndicator.setState LoadingIndicator.types.ANNOTATIONS, true

    Meteor.subscribe 'streamMessages', streamId, ->
      console.log "Loaded " + StreamMessages.find().count() + " stream messages"

    Meteor.subscribe 'messageAnnotations', messageId, ->
      console.log "Loaded " + MessageAnnotations.find().count() + " annotations"
      loadingIndicator.setState LoadingIndicator.types.ANNOTATIONS, false

    Meteor.subscribe 'users', userId
    Meteor.subscribe 'streams', userId
    Meteor.subscribe 'invitations', userId

  watchUser()