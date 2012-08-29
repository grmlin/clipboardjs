do() ->
  ABSTRACT_LENGTH = 100
  
  Meteor.methods
    createMessage: (userId, boardId, content, type) ->
      message_full = content
      message_abstract = content.slice 0, ABSTRACT_LENGTH
      
      switch type
        when "HTML" 
          message_full = HTML YEAH + message_full
        when "Javascript"
          message_full = message_full
        else
          message_full = message_full


      newid = Messages.insert
        user_id: userId
        user_name: Users.findOne(userId )?.user_name
        time: (new Date()).getTime()
        board_id: boardId
        abstract: message_abstract
        message: message_full
        
      return newid
