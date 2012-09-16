Template.stream_list.show = ->
  streamId = Session.get(SESSION_SHORT_STREAM_ID)
  isRightState = appState.getState() is appState.STREAM

  isRightState and streamId isnt ""
  
Template.stream_list.events = 
  'click .prettyprint code': (evt) ->
    code = evt.currentTarget
    message = StreamMessages.findOne({short_id:code.getAttribute('data-message-id')})
    isAbstract = code.getAttribute("data-is-abstract") is "yes"
    
    if isAbstract
      code.setAttribute "data-is-abstract", "no"
      content = message.highlighted
    else
      code.setAttribute "data-is-abstract", "yes"
      content = message.abstract
      
    code.innerHTML = content