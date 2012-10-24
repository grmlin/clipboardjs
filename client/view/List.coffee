do ->
  Template.list.helpers
    is_pasting: ->
      appState.isState appState.LIST

    are_messages_available: ->
      Messages.find({stream_id: null}).count() > 0

    are_streams_available: ->
      Streams.find({users: Meteor.userId()}).count() > 0

    messages: ->
      Messages.find({
      $and: [
        {
        stream_id: null
        user_id: usersController.getUserId()
        }
      ]
      }, {
      sort:
        time: -1
      })

    streams: ->
      Streams.find({users: Meteor.userId()},
        {sort:
          {time: -1}
        })

    message_count: ->
      messagePagination.getCount()

    stream_count: ->
      streamsPagination.getCount()


    has_more_messages: () ->
      messagePagination.hasMore()

    has_less_messages: () ->
      messagePagination.hasLess()

    has_more_streams: () ->
      streamsPagination.hasMore()

    has_less_streams: () ->
      streamsPagination.hasLess()


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