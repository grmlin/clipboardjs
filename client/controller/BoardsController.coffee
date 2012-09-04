BoardsController = do () ->
  #remove = Boards.remove
  insert = Boards.insert
  doInsert = ->
    insert.apply Boards, arguments

  update = Boards.update
  doUpdate = ->
    update.apply Boards, arguments

  Boards.remove = ->
  Boards.insert = ->
  Boards.update = ->


  class BoardsController
    constructor: ->

    resetBoardSession: ->
      Session.set SESSION_BOARD_ID, ""
      Session.set SESSION_BOARD_TITLE, ""

    createBoard: (title, isPrivate = false) ->
      userid = Session.get(SESSION_USER)

      newid = doInsert
        user_id: userid
        user_name: Users.findOne(userid)?.user_name
        time: (new Date()).getTime()
        title: title
        is_private: isPrivate

      boardsRouter.navigate "/board/#{newid}", trigger: true

    deleteBoard: (userId, boardId) ->
      Meteor.call("deleteBoard", userId, boardId, (err, wasSuccessful) ->
        boardsRouter.navigate("/list", trigger: true) if typeof err is "undefined"
      )
    #TODO validate user
    setBoardName: (board_id, name)->
      doUpdate(board_id, $set:
        {title: name})

    updateUserName: (id, name) ->
      doUpdate(
        {user_id: id},
        {$set:
          {user_name: name}
        }, multi: true
      )

    isOwner: (user_id, board_id) ->
      board = Boards.findOne board_id
      user_id is board?.user_id

    canViewBoard: (user_id, board_id) ->
      board = Boards.findOne board_id
      not board?.is_private or (user_id is board?.user_id)