class BoardsController
  constructor: ->

  resetBoardSession: ->
    Session.set SESSION_BOARD_ID, ""

  createBoard: (title = "New Board", isPrivate = false) ->
    userid = Session.get(SESSION_USER)

    newid = Boards.insert
      user_id: userid
      user_name: Users.findOne(userid)?.user_name
      time: (new Date()).getTime()
      title: title
      is_private: isPrivate

    boardsRouter.navigate "/board/#{newid}", trigger: true

  setBoardName: (board_id, name)->
    Boards.update(board_id, $set:
      {title: name})

  canViewBoard: (user_id, board_id) ->
    board = Boards.findOne board_id
    not board?.is_private or (user_id is board?.user_id)
  #Meteor.call "canViewBoard", user_id, board_id, (err, canView) =>
  #  callback.call null, canView

  createMessage: (boardId, message) ->
    userid = Session.get(SESSION_USER)

    newid = Messages.insert
      user_id: userid
      user_name: Users.findOne(userid)?.user_name
      time: (new Date()).getTime()
      board_id: boardId
      message: message