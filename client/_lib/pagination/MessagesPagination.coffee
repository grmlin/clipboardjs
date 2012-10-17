class MessagesPagination extends AbstractPagination
  @N_PER_PAGE: 10

  constructor: () ->
    super(SESSION_MESSAGE_COUNT, MessagesPagination.N_PER_PAGE)

    progress.addSubscription (subscribe) ->
      subscribe 'current_message', Session.get(SESSION_SHORT_MESSAGE_ID)
    
    ###Meteor.autosubscribe =>
      messageId = Session.get SESSION_SHORT_MESSAGE_ID
      Meteor.subscribe 'current_message', messageId, ->
        console.log("message arrived")
    ###
  
    Meteor.autosubscribe =>
      userId = Session.get SESSION_USER
      page = @_getPageNumber()
      
      loadingIndicator?.setState LoadingIndicator.types.MESSAGE_LIST, true

      Meteor.subscribe 'messages', userId, page, @nPerPage, userId, ->
        loadingIndicator?.setState LoadingIndicator.types.MESSAGE_LIST, false

    Messages.find().observe
      added: =>
        @getCollectionCount()
      removed: =>
        @getCollectionCount()

  getCollectionCount: ->
    Meteor.call("getCollectionCount", 'Messages', {user_id: Session.get(SESSION_USER)}, (err, res) ->
      console?.error(err) if err
      Session.set SESSION_MESSAGE_COUNT, res
    )