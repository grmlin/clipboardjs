BoardsRouter = Backbone.Router.extend
  routes:
    "list": "list"
    "board/:board_id": "board"

  list: ->
    console.log("list")
    appState.setState appState.LIST
    boardsController.resetBoardSession()

  board: (board_id) ->
    console.log("board")
    board = Boards.findOne(board_id)
    if typeof board isnt "undefined"
      console.log "board selected"
      appState.setState appState.SHOW
      Session.set SESSION_BOARD_ID, board_id
    else
      console.log "board not available"
      this.navigate "list", trigger: true