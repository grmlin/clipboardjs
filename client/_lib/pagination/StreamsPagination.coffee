class StreamsPagination extends AbstractPagination
  @N_PER_PAGE: 5
  @getCountOptions: ->
    {users: usersController.getUserId()}
  
  constructor: () ->
    super("Streams", StreamsPagination.getCountOptions, StreamsPagination.N_PER_PAGE)

    progress.addSubscription (subscribe) ->
      subscribe 'current_stream', Session.get(SESSION_SHORT_STREAM_ID)
      
    progress.addSubscription (subscribe) =>
      subscribe 'streams', usersController.getUserId(), @_getPageNumber(), @nPerPage
