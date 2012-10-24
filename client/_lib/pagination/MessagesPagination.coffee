class MessagesPagination extends AbstractPagination
  @N_PER_PAGE: 10
  @getCountOptions: ->
    {user_id: usersController.getUserId()}

  constructor: () ->
    super("Messages", MessagesPagination.getCountOptions, MessagesPagination.N_PER_PAGE)

    progress.addSubscription (subscribe) =>
      userId = usersController.getUserId()
      subscribe 'messages', userId, @_getPageNumber(), @nPerPage

    progress.addSubscription (subscribe) ->
      subscribe 'current_message', Session.get(SESSION_SHORT_MESSAGE_ID)

    progress.addSubscription (subscribe) ->
      subscribe 'stream_messages', Session.get(SESSION_SHORT_STREAM_ID)