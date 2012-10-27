do() ->
  ABSTRACT_LENGTH = 160
  ABSTRACT_PUFFER = 10
  ABSTRACT_LINES = 20
  ABSTRACT_LINE_PUFFER = 5

  shortid = meteorNpm.require "shortid"

  # TODO check user ids on existence?
  Meteor.methods
    getMessageCount: (userId) ->
      Messages.find(user_id: userId).count()

    getUserMessages: (userId) ->
      messages = Messages.find user_id: userId
      return messages.fetch()

    getMessage: (shortId, userId) ->
      console.log "loading message #{shortId}"
      message = Messages.findOne short_id: shortId

      throw new Meteor.Error(404, "Message not found") unless message

      throw new Meteor.Error(403, "Access Denied") if message.is_private and userId isnt message.user_id

      return message

    createMessage: (userId, content, type, streamId = null) ->
      highlighter = new Highlighter()
      abstractor = new MessageAbstractor()

      message_raw = content

      messageHighlighted = highlighter.highlight message_raw, type
      messageAbstract = abstractor.getAbstract message_raw, messageHighlighted.language

      newid = Messages.insert
        abstract: messageAbstract
        highlighted: messageHighlighted.value
        is_private: false
        language: messageHighlighted.language
        raw: message_raw
        short_id: shortid.generate()
        stream_id: streamId
        time: (new Date()).getTime()
        user_id: userId
        user_name: Meteor.users.findOne(userId)?.username

      return newid
      
    updateMessageType: (userId, messageId, newType) ->
      message = Messages.findOne messageId
      if message and userId is message.user_id
        Meteor._debug "Updating message #{messageId} type to #{newType}"
        highlighter = new Highlighter()
        abstractor = new MessageAbstractor()
  
        message_raw = message.raw
  
        messageHighlighted = highlighter.highlight message_raw, newType
        messageAbstract = abstractor.getAbstract message_raw, messageHighlighted.language
        Messages.update(messageId, {
          $set:
            {
            abstract: messageAbstract
            highlighted: messageHighlighted.value
            language: messageHighlighted.language
            }
        })  
      else
        new Meteor.Error(500, "Message couldn't be updated")
      
    updateMessageOwner: (oldId, newId) ->
      Messages.update(
          {user_id: oldId},
          {$set:
            {
              user_id: newId,
              user_name: Meteor.users.findOne(newId)?.username
            }
          }, multi: true
        )
      return "messages updated"

    updateAnnotationOwner: (userId, userName) ->
      MessageAnnotations.update(
        {user_id: userId},
        {$set:
          {user_name: userName}
        }, multi: true
      )