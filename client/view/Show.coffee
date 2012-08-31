Template.show.is_authorized = ->
  boardsController.canViewBoard(Session.get(SESSION_USER), Session.get(SESSION_BOARD_ID))

Template.show.is_owner = ->
  boardsController.isOwner(Session.get(SESSION_USER), Session.get(SESSION_BOARD_ID))

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

Template.show.are_messages_available = ->
  Messages.find({board_id: Session.get(SESSION_BOARD_ID)}).count() > 0
Template.show.messages = ->
  Messages.find({board_id: Session.get(SESSION_BOARD_ID)},
    {sort:
      {time: -1}
    }).fetch().slice(0, 10)

Template.show.events =
  "click .paste-text-board:not(:disabled)": (evt) ->
    $button = $(evt.currentTarget)
    txt = $button.parent().prevAll('.text-board-wrapper').find("textarea").val()
    type = $button.parent().prevAll('.text-type-wrapper').find("select").val()

    if txt isnt ""
      $button.attr("disabled","disabled")
      messagesController.createMessage Session.get(SESSION_BOARD_ID), txt, type 

  "keyup .board-name .editable-board-title": (evt) ->
    $(evt.currentTarget).parents('li:first').addClass("changed")

  "click .board-name .change": (evt) ->
    text = $(evt.currentTarget).prev('.editable-board-title').text()
    boardsController.setBoardName(Session.get(SESSION_BOARD_ID), text) unless text is ""

  'click .board-actions .delete': (evt) ->
    if confirm("Are you sure?\n The board and all messages will be deleted")
      boardsController.deleteBoard Session.get(SESSION_USER), Session.get(SESSION_BOARD_ID)  
    
  'click .messages-list ul li a': (evt) ->
    evt.preventDefault()
    boardsRouter.navigate evt.currentTarget.getAttribute("href"), trigger: true
    
  'dragenter .file-drop': (evt) ->
    $(evt.currentTarget).addClass('over')

  'dragleave .file-drop': (evt) ->
    $(evt.currentTarget).removeClass('over')

  'drop .file-drop': (evt) ->
    evt.preventDefault()
    target = evt.currentTarget
    text = $(evt.currentTarget).removeClass('over').find('textarea')

    files = evt.dataTransfer.files
    for file in files
      do (file) ->
        reader = new FileReader()
        reader.onload = (readerEvent) ->
          text.val readerEvent.target.result
    
        reader.readAsText(file)  