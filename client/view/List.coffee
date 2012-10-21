do ->
  Template.list.helpers
    show: ->
      Session.get SESSION_USER

    is_pasting: ->
      appState.getState() is appState.LIST

    are_messages_available: ->
      Messages.find({stream_id: null}).count() > 0

    are_bookmarked_messages_available: ->
      Messages.find({bookmarked_by: Session.get(SESSION_USER)}).count() > 0

    are_streams_available: ->
      Streams.find({users: Session.get(SESSION_USER)}).count() > 0

    messages: ->
      Messages.find({
      $and: [
        {stream_id: null}
      ]
      }, {
      sort:
        time: -1
      })

    has_more_messages: () ->
      messagePagination.hasMore()

    has_less_messages: () ->
      messagePagination.hasLess()

    bookmarked_messages: ->
      Messages.find({bookmarked_by: Session.get(SESSION_USER)},
        {sort:
          {time: -1}
        }).fetch().slice(0, 10)

    streams: ->
      Streams.find({users: Session.get(SESSION_USER)},
        {sort:
          {time: -1}
        })
      
    has_more_streams: () ->
      streamsPagination.hasMore()

    has_less_streams: () ->
      streamsPagination.hasLess()

    message_count: ->
      messagePagination.getCount()

    stream_count: ->
      streamsPagination.getCount()

  bookmark_count = ->
    Messages.find({bookmarked_by: Session.get(SESSION_USER)}).count()

  Template.list.events =
    'click .show-more-messages': (evt) ->
      messagePagination.next()

    'click .show-less-messages': (evt) ->
      messagePagination.back()
    
    'click .show-more-streams': (evt) ->
      streamsPagination.next()

    'click .show-less-streams': (evt) ->
      streamsPagination.back()

    'click .new-stream': (evt) ->
      evt.preventDefault()
      messagesController.createStream (id) ->
        #boardsRouter.navigate "/stream/#{id}", trigger: true # will not work as the data isnt synced atm