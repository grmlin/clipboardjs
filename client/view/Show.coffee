Template.show.show = ->
  isRightState = appState.getState() is appState.LIST
  isRightState and Session.get SESSION_USER

Template.show.is_editable = ->
  boardsController.isOwner(Session.get(SESSION_USER),Session.get(SESSION_BOARD_ID))
  
Template.show.board_name = ->
  board = Boards.findOne(Session.get(SESSION_BOARD_ID))
  return if board then board.title else "UNKNOWN"

Template.show.user_name = ->
  Boards.findOne(Session.get(SESSION_BOARD_ID))?.user_name


Template.show.events =
  "click .paste-text-board:not(:disabled)": (evt) ->
    $button = $(evt.currentTarget)
    txt = $button.parents('.show').find("textarea").val()
    type = $button.parents('.show').find("select[name=text-type]").val()

    if txt isnt ""
      $button.attr("disabled","disabled")
      messagesController.createMessage txt, type, ->
        $button.removeAttr("disabled")
        $button.parents('.show').find("textarea").val("")

  "keyup .board-name .editable-board-title": (evt) ->
    $(evt.currentTarget).parents('li:first').addClass("changed")

  "click .board-name .change": (evt) ->
    text = $(evt.currentTarget).prev('.editable-board-title').text()
    boardsController.setBoardName(Session.get(SESSION_BOARD_ID), text) unless text is ""

  'click .board-actions .delete': (evt) ->
    if confirm("Are you sure?\n The board and all messages will be deleted")
      boardsController.deleteBoard Session.get(SESSION_USER), Session.get(SESSION_BOARD_ID)  
    
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