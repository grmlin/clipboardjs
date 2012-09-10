do ->
  monthNames = [ "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December" ]

  createPopover = (link) ->
    $('.popover').remove()
    link.popover({delay:
      { show: 0, hide: 0 }})
    template = link.data().popover?.options.template.replace 'class="popover"', 'class="popover message-abstract"'
    link.data().popover?.options.template = template

  Template.list.show = ->
    Session.get SESSION_USER

  Template.list.is_pasting = ->
    appState.getState() is appState.LIST

  Template.list.are_messages_available = ->
    Messages.find({user_id: Session.get(SESSION_USER)}).count() > 0

  Template.list.are_bookmarked_messages_available = ->
    Messages.find({bookmarked_by: Session.get(SESSION_USER)}).count() > 0

  Template.list.are_streams_available = ->
    Streams.find({users: Session.get(SESSION_USER)}).count() > 0

  Template.list.messages = ->
    Messages.find({user_id: Session.get(SESSION_USER)},
      {sort:
        {time: -1}
      }).fetch().slice(0, 10)

  Template.list.bookmarked_messages = ->
    Messages.find({bookmarked_by: Session.get(SESSION_USER)},
      {sort:
        {time: -1}
      }).fetch().slice(0, 10)

  Template.list.streams = ->
    Streams.find({users: Session.get(SESSION_USER)},
      {sort:
        {time: -1}
      }).fetch().slice(0, 10)

  Template.message_abstr.rendered = ->
    #createPopover($(this.find('a')))

  Template.message_bookmarked_abstr.rendered = ->
    #createPopover($(this.find('a')))

  Template.message_abstr.get_date = (time)->
    date = new Date(time)
    day = date.getDay()
    month = monthNames[date.getMonth()]
    year = date.getYear()
    month.toString() + " " + day.toString() + ", " + year.toString()

  Template.message_abstr.is_active = (id)->
    id is Session.get(SESSION_SHORT_MESSAGE_ID)
  ### and Messages.find(
{short_id:id},
{$and:{user_id: Session.get(SESSION_USER),bookmarked_by:Session.get(SESSION_USER)}}
).count() is 0                                 ###

  Template.message_bookmarked_abstr.is_active = (id)->
    id is Session.get SESSION_SHORT_MESSAGE_ID

  Template.stream_abstr.is_active = (id) ->
    id is Session.get SESSION_SHORT_STREAM_ID
    
  Template.list.events =
    'click .new-stream': (evt) ->
      evt.preventDefault()
      messagesController.createStream (id) ->
        #boardsRouter.navigate "/stream/#{id}", trigger: true # will not work as the data isnt synced atm