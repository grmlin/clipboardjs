Template.list.is_active = ->
  state = appState.getState()
  state is appState.LIST

Template.list.show_boards = ->
  state = appState.getState()
  #(state is appState.LIST or state is appState.MESSAGE) #and (Session.get(SESSION_BOARD_ID) is "")
  true
  
Template.list.show_messages = ->
  state = appState.getState()
  (state is appState.SHOW or state is appState.MESSAGE) and (Session.get(SESSION_BOARD_ID) isnt "")

Template.board_list.are_boards_available = ->
  Boards.find().count() > 0
  
Template.board_list.available_boards = ->
  boards = Boards.find({}, {sort: {time: -1}})
  console.log "#{boards.count()} boards found"
  boards

Template.board.is_active = (id) ->
  id is Session.get(SESSION_BOARD_ID)
  
Template.board.is_locked = (id) ->
  not boardsController.canViewBoard(Session.get(SESSION_USER), id)

Template.board.is_editable = (boardId)->
  boardsController.isOwner(Session.get(SESSION_USER),boardId)

Template.board.are_messages_available = ->
  Messages.find({board_id: Session.get(SESSION_BOARD_ID)}).count() > 0

Template.board.messages = ->
  Messages.find({board_id: Session.get(SESSION_BOARD_ID)},
    {sort:
      {time: -1}
    }).fetch().slice(0, 10)
  
Template.board.events =
  'click .icon-pencil': (evt) ->
    title = $(evt.currentTarget).parent().nextAll('.board-title')
    title.attr("contenteditable","true").focus()
    
  "click a": (evt) ->
    evt.preventDefault()
    boardsRouter.navigate evt.currentTarget.getAttribute("href"), trigger: true unless $(evt.currentTarget).parent().hasClass("locked")