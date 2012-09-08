MessagesController = do () ->
  Messages.remove = ->
  Messages.insert = ->
  Messages.update = ->
  
  class MessagesController
    resetMessageSession: ->
      Session.set SESSION_SHORT_MESSAGE_ID, ""
      
    canViewMessage: (user_id, message_id) ->
      message = Messages.findOne(message_id)
      user_id is message.user_id
  
    createMessage: (message, type, callback) ->
      userId = Session.get(SESSION_USER)
      Meteor.call("createMessage", userId, message, type, (err, res) ->
        callback.call(this, res) unless typeof err isnt "undefined"
      )
  
    deleteMessage: (user_id, message_id) ->

    addBookmark: (messageId) ->
      userId = Session.get(SESSION_USER)
      Meteor.call("addMessageBookmark", userId, messageId, (err, res) ->
        console?.error err if typeof err isnt "undefined"
      )

    deleteBookmark: (messageId) ->
      userId = Session.get(SESSION_USER)
      Meteor.call("deleteMessageBookmark", userId, messageId, (err, res) ->
        console?.error err if typeof err isnt "undefined"
      )

    updateUserName: (userId, userName) ->
      Meteor.call "updateMessageOwner", userId, userName, (err, res) ->
        console?.log err, res
      
    getHighlightedMessage: (messageShortId, callback) ->
      Meteor.call("getHighlightedMessage", Session.get(SESSION_USER), messageShortId, (err, message) ->
        callback.call this, message
      )

    getRawMessage: (messageId, callback) ->
      Meteor.call("getRawMessage", Session.get(SESSION_USER), messageId, (err, message) ->
        callback.call this, message
      )
      
    