MessagesController = do () ->
  remove = Messages.remove
  insert = Messages.insert
  update = Messages.update
  
  Messages.remove = ->
  Messages.insert = ->
  Messages.update = ->
  
  class MessagesController
    resetMessageSession: ->
      Session.set SESSION_MESSAGE_ID, ""
      
    canViewMessage: (user_id, message_id) ->
      message = Messages.findOne(message_id)
      boardsController.canViewBoard user_id, message.board_id
  
    createMessage: (boardId, message, type) ->
      userId = Session.get(SESSION_USER)
      Meteor.call("createMessage", userId, boardId, message, type, (err, res) ->
        console.log res
      )
  
    deleteMessage: (user_id, message_id) ->
      
      
    getHighlightedMessage: (messageId, callback) ->
      Meteor.call("getHighlightedMessage", Session.get(SESSION_USER), messageId, (err, message) ->
        callback.call this, message
      )

    getRawMessage: (messageId, callback) ->
      Meteor.call("getRawMessage", Session.get(SESSION_USER), messageId, (err, message) ->
        callback.call this, message
      )
      
    