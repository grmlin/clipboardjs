class AbstractPagination
  constructor: (@collectionName, @countOptionsCb, @nPerPage = 10) ->
    @sessionCountKey = "#{@collectionName}_pagination_count"
    @sessionPageNumberKey = "#{@collectionName}_pagination_page_number"
    
    Session.set @sessionCountKey, 0

    window[@collectionName].find().observe
      added: =>
        @_getCollectionCount()
      removed: =>
        @_getCollectionCount()
        
    @_setPageNumber()

  _getCollectionCount: ->
    Meteor.call("getCollectionCount", @collectionName, @countOptionsCb(), (err, res) =>
      console?.error(err) if err
      Session.set @sessionCountKey, res
    )
    
  _getPageNumber: ->
    Session.get @sessionPageNumberKey
  
  _setPageNumber: (page = 1) ->
    Session.set @sessionPageNumberKey, page

  hasMore: ->
    @_getPageNumber() * @nPerPage < Session.get(@sessionCountKey)
  
  hasLess: ->
    @_getPageNumber() > 1
  
  getCount: ->
    Session.get @sessionCountKey
    
  next: ->
    page = @_getPageNumber()
    @_setPageNumber(page + 1) if @hasMore()

  back: ->
    page = @_getPageNumber()
    @_setPageNumber(page - 1) if page > 1