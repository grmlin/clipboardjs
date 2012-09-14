do ->
  Template.list.helpers
    show: ->
      Session.get SESSION_USER

    is_pasting: ->
      appState.getState() is appState.LIST

    are_messages_available: ->
      Messages.find({user_id: Session.get(SESSION_USER), stream_id: null}).count() > 0

    are_bookmarked_messages_available: ->
      Messages.find({bookmarked_by: Session.get(SESSION_USER)}).count() > 0

    are_streams_available: ->
      Streams.find({users: Session.get(SESSION_USER)}).count() > 0

    messages: ->
      Messages.find(
        {
        user_id: Session.get(SESSION_USER),
        stream_id: null
        },
        {sort:
          {time: -1}
        }).fetch().slice(0, 10)

    bookmarked_messages: ->
      Messages.find({bookmarked_by: Session.get(SESSION_USER)},
        {sort:
          {time: -1}
        }).fetch().slice(0, 10)

    streams: ->
      Streams.find({users: Session.get(SESSION_USER)},
        {sort:
          {time: -1}
        }).fetch().slice(0, 10)

    message_count: ->
      Messages.find({user_id: Session.get(SESSION_USER), stream_id: null}).count()

    stream_count: ->
      Streams.find({users: Session.get(SESSION_USER)}).count()

    bookmark_count = ->
      Messages.find({bookmarked_by: Session.get(SESSION_USER)}).count()

  Template.list.events =
    'click .new-stream': (evt) ->
      evt.preventDefault()
      messagesController.createStream (id) ->
        #boardsRouter.navigate "/stream/#{id}", trigger: true # will not work as the data isnt synced atm