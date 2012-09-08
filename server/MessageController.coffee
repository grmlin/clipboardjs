do() ->
  ABSTRACT_LENGTH = 160

  highlight = meteorNpm.require "highlight.js"
  shortid = meteorNpm.require "shortid"

  Meteor.methods
    getUserMessages: (userId) ->
      messages = Messages.find user_id: userId
      return messages.fetch()

    getMessage: (shortId, userId) ->
      console.log "loading message #{shortId}"
      message = Messages.findOne short_id: shortId
      throw new Meteor.Error(404, "Message not found") unless message

      throw new Meteor.Error(403, "Access Denied") if message.is_private and userId isnt message.user_id
      
      return message



    getHighlightedMessage: (userId, shortId) ->
      #TODO validation "canView..." for server and client
      console.log "loading message #{shortId}"
      message = Messages.findOne short_id: shortId
      if typeof message isnt "undefined"
        return "<code class=#{message.language}>#{message.highlighted}</code>"
      else
        throw new Meteor.Error(404, "Message not found")

    getRawMessage: (userId, shortId) ->
      message = Messages.findOne short_id: shortId
      if typeof message isnt "undefined"
        return message.raw
      else
        throw new Meteor.Error(404, "Message not found")

    createMessage: (userId, content, type) ->
      message_raw = content
      message_abstract = content.slice 0, ABSTRACT_LENGTH
      message_highlighted = ""
      highlightResult = null
      lang = null

      switch type
        when "auto"
          highlightResult = highlight.highlightAuto message_raw
        when "html"
          highlightResult = highlight.highlight "xml", message_raw
        when "javascript"
          highlightResult = highlight.highlight "javascript", message_raw
        when "coffeescript"
          highlightResult = highlight.highlight "coffeescript", message_raw
        when "plain"
          message_highlighted = message_raw
          lang = "plain"
        else
          message_highlighted = message_raw
          lang = "plain"

      message_highlighted = highlightResult.value if highlightResult isnt null
      lang = highlightResult.language if lang is null


      newid = Messages.insert
        abstract: message_abstract
        bookmarked_by: []
        highlighted: message_highlighted
        is_private: false
        language: lang
        raw: message_raw
        short_id: shortid.generate()
        time: (new Date()).getTime()
        user_id: userId
        user_name: Users.findOne(userId)?.user_name

      return newid

    addMessageBookmark: (userId, shortId) ->
      Messages.update {short_id: shortId}, {$addToSet:{bookmarked_by:userId}}

    deleteMessageBookmark: (userId, shortId) ->
      Messages.update {short_id: shortId}, {$pull:{bookmarked_by:userId}}
      
    updateMessageOwner: (userId, userName) ->
      Messages.update(
        {user_id: userId},
        {$set:
          {user_name: userName}
        }, multi: true
      )
      return "messages updated"