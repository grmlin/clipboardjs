Handlebars.registerHelper 'is_user', (input) ->
  Meteor.userId() isnt null
  
Handlebars.registerHelper 'message_comment_count',  (messageId) ->
  MessageAnnotations.find({message_id: messageId}).count()

Handlebars.registerHelper 'is_message_opened',  () ->
  messageId = Session.get(SESSION_SHORT_MESSAGE_ID)
  isRightState = appState.getState() is appState.MESSAGE
  isMessageSelected = messageId isnt ""

  isRightState and isMessageSelected

