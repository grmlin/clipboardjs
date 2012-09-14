Template.blocker.helpers
  block : ->
    appState.isState(appState.LOADING) or appState.isState(appState.LOADED)