appState = do() ->
  appState =
    LOADING : "loading"
    LOADED: "loaded"
    LIST : "list"
    SHOW : "show"
    
    setState: (state) ->
      Session.set(SESSION_STATE, state)
    
    getState: ->
      Session.get(SESSION_STATE)

  

  appState.setState(appState.LOADING)

  appState
  