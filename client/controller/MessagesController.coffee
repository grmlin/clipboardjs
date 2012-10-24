MessagesController = do () ->
  
  class MessagesController
    constructor: ->
      checkUser = =>
        ctx = new Meteor.deps.Context()
        ctx.on_invalidate(checkUser)
        ctx.run =>
          userId = Meteor.userId()
          unless userId is null
            @updateUserName(usersController.getTempUserId(), userId)
    
      checkUser()
      
    resetMessageSession: ->
      Session.set SESSION_SHORT_MESSAGE_ID, ""

    resetStreamSession: ->
      Session.set SESSION_SHORT_STREAM_ID, ""
      
    canViewMessage: (user_id, message_id) ->
      message = Messages.findOne(message_id)
      user_id is message.user_id
  
    createMessage: (message, type, callback) ->
      @createStreamMessage message, type, null, callback
  
    #TODO handle anonymous messages
    createStreamMessage: (message, type, streamId, callback = ->) ->
      userId = usersController.getUserId()
      Meteor.call("createMessage", userId, message, type, streamId, (err, res) ->
        console?.error(err) if err
        callback.call(this, res) unless typeof err isnt "undefined"
      )
      
    createStream: (callback) ->
      userId = Meteor.userId()
      Meteor.call("createStream", userId, (err, res) ->
        console?.error err if err
        callback.call(this, res)
      )

    joinStream: (streamShortId) ->
      userId = Meteor.userId()
      Meteor.call("joinStream", streamShortId, userId, (err,res) ->
        if typeof err isnt "undefined"
          alert err.reason
        else 
          boardsRouter.navigate "/stream/#{streamShortId}", trigger:true
      )

    leaveStream: (streamShortId) ->
      userId = Meteor.userId()
      Meteor.call("leaveStream", streamShortId, userId, (err,res) ->
        alert err.reason if err
        boardsRouter.navigate "/list", trigger: true
      )
      
    deleteStream: (streamShortId) ->
      userId = Meteor.userId()
      Meteor.call("deleteStream", streamShortId, userId, (err,res) ->
        alert err.reason if err
        boardsRouter.navigate "/list", trigger:true
      )
      
    deleteMessage: (user_id, message_id) ->

    updateUserName: (oldId, newId) ->
      Meteor.call "updateMessageOwner", oldId, newId, (err, res) ->
        console?.log err, res    