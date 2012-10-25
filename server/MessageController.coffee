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