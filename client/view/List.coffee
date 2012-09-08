do ->
  createPopover = (link) ->
    $('.popover').remove()
    link.popover({delay: { show: 0, hide: 0 }})
    template = link.data().popover?.options.template.replace 'class="popover"', 'class="popover message-abstract"'
    link.data().popover?.options.template = template
    
  Template.list.show = ->
    Session.get SESSION_USER
  
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
  
  Template.message_abstr.rendered = ->
    createPopover($(this.find('a')))

  Template.message_bookmarked_abstr.rendered = ->
    createPopover($(this.find('a')))
    
  Template.message_abstr.is_active = (id)->
    id is Session.get(SESSION_SHORT_MESSAGE_ID) and Messages.find({user_id: Session.get(SESSION_USER),bookmarked_by:Session.get(SESSION_USER)}).count() is 0
    
  Template.message_bookmarked_abstr.is_active = (id)->
    id is Session.get SESSION_SHORT_MESSAGE_ID