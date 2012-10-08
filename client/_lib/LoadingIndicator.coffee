class LoadingIndicator
  @types:
    ANNOTATIONS: 
      sessionKey: "loading.annotations"
      hint: "Loading comments..."
  
    MESSAGE_LIST:
      sessionKey: "loading.message_list"
      hint: "loading available messages..."
      
  constructor: ->
    @setState(type, true) for own key, type of LoadingIndicator.types
  
  setState: (type, isLoading) ->
    Session.set type.sessionKey, isLoading
    
  isLoading: (type) ->
    Session.get type.sessionKey
    
  getLoadingItems: ->
    items = []
    for own key, type of LoadingIndicator.types
      items.push(type.hint) if @isLoading(type)
      
    return items