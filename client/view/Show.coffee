Template.show.is_authorized = ->
  boardsController.canViewBoard(Session.get(SESSION_USER), Session.get(SESSION_BOARD_ID))


Template.show.show = ->
  boardId = Session.get(SESSION_BOARD_ID)
  isRightState = appState.getState() is appState.SHOW
  isBoardSelected = boardId isnt ""

  isRightState and isBoardSelected

Template.show.board_name = ->
  board = Boards.findOne(Session.get(SESSION_BOARD_ID))
  return if board then board.title else "UNKNOWN"

Template.show.user_name = ->
  Boards.findOne(Session.get(SESSION_BOARD_ID))?.user_name


Template.show.messages = ->
  Messages.find({board_id: Session.get(SESSION_BOARD_ID)},
    {sort:
      {time: -1}
    }).fetch().slice(0, 10)

Template.show.events =
  "click .paste-text-board": (evt) ->
    txt = $(evt.currentTarget).parent().prev().val()
    boardsController.createMessage Session.get(SESSION_BOARD_ID), txt unless txt is ""

  "keyup .board-name .editable-board-title": (evt) ->
    $(evt.currentTarget).parent().addClass("changed")

  "click .board-name .change": (evt) ->
    boardsController.setBoardName(Session.get(SESSION_BOARD_ID), $(evt.currentTarget).prev('.editable-board-title').text())          