Meteor.methods
  deleteBoard: (userId, boardId) ->
    Boards.remove({_id: boardId, user_id: userId})
    Messages.remove({board_id: boardId})