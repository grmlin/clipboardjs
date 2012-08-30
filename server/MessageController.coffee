do() ->
  ABSTRACT_LENGTH = 100

  require = __meteor_bootstrap__.require
  highlight = require "highlight.js"

  Meteor.methods
    getHighlightedMessage: (userId, messageId) ->
      #TODO validation "canView..." for server and client
      message = Messages.findOne messageId
      if typeof message isnt "undefined"
        return "<code class=#{message.language}>#{message.highlighted}</code>"
      else 
        throw new Meteor.Error(404, "Message not found")

    getRawMessage: (userId, messageId) ->
      message = Messages.findOne messageId
      if typeof message isnt "undefined"
        return message.raw
      else
        throw new Meteor.Error(404, "Message not found")
        
    createMessage: (userId, boardId, content, type) ->
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
        user_id: userId
        user_name: Users.findOne(userId)?.user_name
        time: (new Date()).getTime()
        board_id: boardId
        abstract: message_abstract
        raw: message_raw
        highlighted: message_highlighted
        language: lang

      return newid
