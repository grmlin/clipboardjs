Template.breadcrumb.items = ->
  items = []
  switch appState.getState()
    when appState.LIST
      items.push 
        title : "Boards"
        
    when appState.SHOW
      items.push
        href : "/list"
        title : "Boards"
      items.push
        title : Session.get SESSION_BOARD_TITLE
        
    when appState.MESSAGE
      items.push
        href : "/list"
        title : "Boards"
      items.push
        href: "/board/#{Session.get(SESSION_BOARD_ID)}"
        title : Session.get SESSION_BOARD_TITLE
      items.push
        title : "Message"
        
    else
      items.push
        title : "Home"
        
  return items