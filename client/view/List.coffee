Template.list.show = ->
  Session.get SESSION_USER

Template.list.rendered = ->
  #if Session.get SESSION_USER
    #Meteor.call "getUserMessages", Session.get(SESSION_USER), (err, data) =>
    #  this.find(".messages-list")?.innerHTML = Template.messages_list(data) unless typeof err isnt "undefined"
  
Template.list.is_pasting = ->
  appState.getState() is appState.LIST
  
Template.list.are_messages_available = ->
  Messages.find({user_id:Session.get(SESSION_USER)}).count() > 0
  
Template.list.are_bookmarked_messages_available = ->
  Messages.find({bookmarked_by:Session.get(SESSION_USER)}).count() > 0
  
  
Template.list.messages = ->
  Messages.find({user_id: Session.get(SESSION_USER)},
    {sort:
      {time: -1}
    }).fetch().slice(0, 10)
  
Template.list.bookmarked_messages = ->
  Messages.find({bookmarked_by:Session.get(SESSION_USER)},
    {sort:
      {time: -1}
    }).fetch().slice(0, 10)

Template.message_abstr.is_active = (id)->
  id is Session.get(SESSION_SHORT_MESSAGE_ID) and Messages.find({user_id: Session.get(SESSION_USER),bookmarked_by:Session.get(SESSION_USER)}).count() is 0
  
Template.message_bookmarked_abstr.is_active = (id)->
  id is Session.get SESSION_SHORT_MESSAGE_ID
  
Template.list.show_messages = ->
  state = appState.getState()
  (state is appState.SHOW or state is appState.MESSAGE) and (Session.get(SESSION_BOARD_ID) isnt "")