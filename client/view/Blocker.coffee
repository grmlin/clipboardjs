Template.blocker.block = ->
  state = appState.getState()
  state is appState.LOADING or state is appState.LOADED