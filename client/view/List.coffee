Template.list.show = ->
  state = appState.getState()
  (state is appState.LIST) and (Session.get(SESSION_BOARD_ID) is "")

Template.board_list.are_boards_available = ->
  Boards.find().count() > 0
  
Template.board_list.available_boards = ->
  boards = Boards.find({}, {sort: {time: -1}})
  console.log "#{boards.count()} boards found"
  boards

Template.board.is_locked = (id) ->
  not boardsController.canViewBoard(Session.get(SESSION_USER), id)
  
Template.board.events =
  "click a": (evt) ->
    evt.preventDefault()
    boardsRouter.navigate evt.currentTarget.getAttribute("href"), trigger: true unless $(evt.currentTarget).parent().hasClass("locked")