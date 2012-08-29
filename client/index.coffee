boardsRouter = new BoardsRouter()
boardsController = new BoardsController()
usersController = new UsersController()

Meteor.startup ->
  areUsersLoaded = false
  boardsController.resetBoardSession()

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
      if Session.get(SESSION_STATE) is appState.LOADING
        appState.setState(appState.LOADED)
        Backbone.history.start({pushState: true})

        if Backbone.history.fragment is ""
          boardsRouter.navigate "list", trigger: true

    Meteor.subscribe 'messages'
