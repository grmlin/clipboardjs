BoardsRouter = Backbone.Router.extend
  routes:
    "list": "list"
    "board/:board_id": "board"
    "message/:message_id": "message"
  _closeRawFileDialog: ->
    $('.raw-file .close').click()
    
  list: ->
    @_closeRawFileDialog()
    appState.setState appState.LIST
    boardsController.resetBoardSession()
    messagesController.resetMessageSession()

  # TODO dry! Abstract controller needed
  board: (board_id) ->
    @_closeRawFileDialog()
    board = Boards.findOne(board_id)
    
    if typeof board isnt "undefined"
      appState.setState appState.SHOW
      messagesController.resetMessageSession()
      Session.set SESSION_BOARD_ID, board_id
    else
      this.navigate "list", trigger: true

  message: (message_id) ->
    @_closeRawFileDialog()
    message = Messages.findOne message_id
    
    if typeof message isnt "undefined"
      appState.setState appState.MESSAGE
      boardsController.resetBoardSession()
      Session.set SESSION_MESSAGE_ID, message_id
    else
      this.navigate "list", trigger: true