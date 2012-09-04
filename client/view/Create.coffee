Template.create.show = ->
  state = appState.getState()
  (state is appState.LIST) and (Session.get(SESSION_BOARD_ID) is "")
  
Template.create.events = 
  
  "click button" : (event) ->
    $modal = $ Template.board_create_modal()
    $('body').append $modal
    $modal.removeClass "hide fade"
    
    $modal.on "click", ".save", =>
      title = $modal.find("[name=board-title]").val()
      title = "Empty Board" if title is ""
      #Meteor.call 'getPwHash', "Test", (err, res) ->
      boardsController.createBoard(title, $modal.find("[name=board-private]").is ":checked")
      $modal.remove()
        
    $modal.on "click", ".cancel, .close", =>
      $modal.remove()