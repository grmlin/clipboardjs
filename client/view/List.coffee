Template.list.show = ->
  state = appState.getState()
  (state is appState.LIST) and (Session.get(SESSION_BOARD_ID) is "")

Template.board_list.are_boards_available = ->
  Boards.find().count() > 0
  
Template.board_list.available_boards = ->
  boards = Boards.find({}, {sort: {time: -1}})
  console.log "#{boards.count()} boards found"
  boards

  
Template.board.events =
  "click a": (evt) ->
    evt.preventDefault()
    console.log(evt.currentTarget.getAttribute("href"))
    boardsRouter.navigate evt.currentTarget.getAttribute("href"), trigger: true