boardsRouter = new BoardsRouter()
usersController = new UsersController()
messagesController = new MessagesController()

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
    streamId = Session.get(SESSION_SHORT_STREAM_ID)
    console.log("user: #{userId} | stream: #{streamId}")
    Meteor.subscribe 'messages', userId, streamId
    Meteor.subscribe 'users', userId
    Meteor.subscribe 'streams', userId
    
  watchUser()