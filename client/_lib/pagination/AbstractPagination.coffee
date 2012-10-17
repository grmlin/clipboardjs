class AbstractPagination
  constructor: (@sessionCountKey, @nPerPage = 10) ->
    @sessionPageNumberKey = "#{@sessionCountKey}_page_number"
    
    Session.set @sessionCountKey, 0
    @_setPageNumber()

  _getPageNumber: ->
    Session.get @sessionPageNumberKey
  
  _setPageNumber: (page = 1) ->
    Session.set @sessionPageNumberKey, page

  hasMore: ->
    @_getPageNumber() * @nPerPage < Session.get(@sessionCountKey)
  
  hasLess: ->
    @_getPageNumber() > 1
    
  next: ->
    page = @_getPageNumber()
    @_setPageNumber(page + 1) if @hasMore()

  back: ->
    page = @_getPageNumber()
    @_setPageNumber(page - 1) if page > 1