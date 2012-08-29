Template.show.is_authorized = ->
  boardsController.canViewBoard(Session.get(SESSION_USER), Session.get(SESSION_BOARD_ID))


Template.show.show = ->
  boardId = Session.get(SESSION_BOARD_ID)
  isRightState = appState.getState() is appState.SHOW
  isBoardSelected = boardId isnt ""

  isRightState and isBoardSelected

Template.show.is_editable = ->
  boardsController.isOwner(Session.get(SESSION_USER),Session.get(SESSION_BOARD_ID))
  
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
    $textarea = $(evt.currentTarget)
    txt = $textarea.parent().prevAll('.text-board-wrapper').find("textarea").val()
    type = $textarea.parent().prevAll('.text-type-wrapper').find("select").val()
    
    boardsController.createMessage Session.get(SESSION_BOARD_ID), txt, type unless txt is ""

  "keyup .board-name .editable-board-title": (evt) ->
    $(evt.currentTarget).parent().addClass("changed")

  "click .board-name .change": (evt) ->
    boardsController.setBoardName(Session.get(SESSION_BOARD_ID), $(evt.currentTarget).prev('.editable-board-title').text())

  'dragenter .text-board': (evt) ->
    $(evt.currentTarget).addClass('over')

  'dragleave .text-board': (evt) ->
    $(evt.currentTarget).removeClass('over')

  'drop .text-board': (evt) ->
    target = evt.currentTarget
    evt.preventDefault()
    $(evt.currentTarget).removeClass('over')

    files = evt.dataTransfer.files
    for file in files
      do (file) ->
        reader = new FileReader()
        reader.onload = (readerEvent) ->
          target.value = readerEvent.target.result
    
        reader.readAsText(file)  