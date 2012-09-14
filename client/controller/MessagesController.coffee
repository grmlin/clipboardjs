MessagesController = do () ->
  Messages.remove = ->
  Messages.insert = ->
  Messages.update = ->
  
  class MessagesController
    resetMessageSession: ->
      Session.set SESSION_SHORT_MESSAGE_ID, ""

    resetStreamSession: ->
      Session.set SESSION_SHORT_STREAM_ID, ""
      
    canViewMessage: (user_id, message_id) ->
      message = Messages.findOne(message_id)
      user_id is message.user_id
  
    createMessage: (message, type, callback) ->
      @createStreamMessage message, type, null, callback
  
    createStreamMessage: (message, type, streamId, callback = ->) ->
      userId = Session.get(SESSION_USER)
      Meteor.call("createMessage", userId, message, type, streamId, (err, res) ->
        console?.error(err) if err
        callback.call(this, res) unless typeof err isnt "undefined"
      )
      
    createStream: (callback) ->
      userId = Session.get(SESSION_USER)
      Meteor.call("createStream", userId, (err, res) ->
        console?.error err if err
        callback.call(this, res)
      )

    joinStream: (streamShortId) ->
      userId = Session.get(SESSION_USER)
      Meteor.call("joinStream", streamShortId, userId, (err,res) ->
        if typeof err isnt "undefined"
          alert err.reason
        else 
          boardsRouter.navigate "/stream/#{streamShortId}", trigger:true
      )

    leaveStream: (streamShortId) ->
      userId = Session.get SESSION_USER
      Meteor.call("leaveStream", streamShortId, userId, (err,res) ->
        alert err.reason if err
        boardsRouter.navigate "/list", trigger: true
      )
      
    deleteStream: (streamShortId) ->
      userId = Session.get SESSION_USER
      Meteor.call("deleteStream", streamShortId, userId, (err,res) ->
        alert err.reason if err
        boardsRouter.navigate "/list", trigger:true
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
      
    