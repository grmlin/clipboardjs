MessagesController = do () ->
  
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
      userId = usersController.getUserId()
      Meteor.call("createMessage", userId, message, type, streamId, (err, res) ->
        console?.error(err) if err
        callback.call(this, res) unless typeof err isnt "undefined"
      )
     
    updateMessageType: (messageId, newType) ->
      userId = usersController.getUserId()
      Meteor.call "updateMessageType", userId, messageId, newType
      
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
      Meteor.call "leaveStream", streamShortId, userId
      
    addAnnotation: (shortMessageId, start, end, comment) ->
      userId = Meteor.userId()
      id = MessageAnnotations.insert
        comment: comment
        message_id: shortMessageId
        start: start
        end: end
        user_id: userId
        author: Meteor.users.findOne(userId)?.username
  
      Meteor._debug "New annotation added: #{id}"
  
      return id


