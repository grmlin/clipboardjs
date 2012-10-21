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
        bookmarked_by: []
        highlighted: messageHighlighted.value
        is_private: false
        language: messageHighlighted.language
        raw: message_raw
        short_id: shortid.generate()
        stream_id: streamId
        time: (new Date()).getTime()
        user_id: userId
        user_name: Users.findOne(userId)?.user_name

      return newid

    addMessageBookmark: (userId, shortId) ->
      Messages.update {short_id: shortId}, {$addToSet:
        {bookmarked_by: userId}}

    deleteMessageBookmark: (userId, shortId) ->
      Messages.update {short_id: shortId}, {$pull:
        {bookmarked_by: userId}}

    updateMessageOwner: (userId, userName) ->
      [Messages, StreamMessages].forEach (collection) ->
        collection.update(
          {user_id: userId},
          {$set:
            {user_name: userName}
          }, multi: true
        )
      return "messages updated"

    addAnnotation: (shortMessageId, userId, start, end, comment) ->
      id = MessageAnnotations.insert
        comment: comment
        message_id: shortMessageId
        start: start
        end: end
        user_id: userId
        author: Users.findOne(userId)?.user_name

      console.log "New annotation added: #{id}"

      return id

    updateAnnotationOwner: (userId, userName) ->
      MessageAnnotations.update(
        {user_id: userId},
        {$set:
          {user_name: userName}
        }, multi: true
      )