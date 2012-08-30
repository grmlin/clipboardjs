boardsRouter = new BoardsRouter()
boardsController = new BoardsController()
messagesController = new MessagesController()
usersController = new UsersController()

Meteor.startup ->
  areUsersLoaded = false
  boardsController.resetBoardSession()

  modelsNeeded = 2
  checkDataAvailability = ->
    modelsNeeded--
    if modelsNeeded is 0
      if Session.get(SESSION_STATE) is appState.LOADING
        appState.setState(appState.LOADED)
        Backbone.history.start({pushState: true})

        if Backbone.history.fragment is ""
          boardsRouter.navigate "list", trigger: true

  $('#logo').click (evt) ->
    evt.preventDefault()
    boardsRouter.navigate "/list", trigger: true

  Meteor.autosubscribe ->
    Meteor.subscribe 'users', ->
      unless areUsersLoaded
        areUsersLoaded = true
        # Get the current user or create a new one
        userid = localStorage[SESSION_USER]
        if typeof userid is "undefined"
          usersController.createUser()
        else
          usersController.loadUser(userid)

    Meteor.subscribe 'boards', ->
      checkDataAvailability()

    Meteor.subscribe 'messages', ->
      checkDataAvailability()
      
