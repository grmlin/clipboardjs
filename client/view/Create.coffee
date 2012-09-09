do ->
  snippet = null
  hightlighted = null
  langNotepad = null 
  
  Template.create.rendered = ->
    snippet = this.find ".text-board"
    hightlighted = this.find ".prettyprint code"
    langNotepad = this.find '[name="current-lang-notepad"]'

    $('.tooltip').remove()
    $(this.findAll('.preview')).tooltip()
    
  Template.create.show = ->
    isRightState = appState.getState() is appState.LIST
    isRightState and Session.get SESSION_USER
  
  Template.create.user_name = ->
    Boards.findOne(Session.get(SESSION_BOARD_ID))?.user_name
  
  
  Template.create.events =
    'click .text-type .dropdown-menu li:not(.active) a': (evt) ->
      $lang = $(evt.currentTarget)
      lang = evt.currentTarget.getAttribute "data-val"
      langDesc = evt.currentTarget.innerHTML
      
      $lang.parents('ul:first').children('.active').removeClass('active')
      $lang.parent().addClass "active"
      
      $lang.parents('.show:first').find('.current-lang').html(langDesc)

      langNotepad.value = lang
    
    'click .preview': (evt) ->
      $button = $ evt.currentTarget
      $view = $button.parents '.show:first'
      $view.toggleClass "previewed"
      isPreviewed = $view.hasClass "previewed"
      
      if isPreviewed and $(snippet).text() isnt ""
        switch langNotepad.value
          when "auto"
            preview = hljs.highlightAuto $(snippet).text()
          when "plain"
            preview = $(snippet).text()
          else
            preview = hljs.highlight langNotepad.value, $(snippet).text()
        
        hightlighted.innerHTML = preview.value
      
    "click .paste-text-board:not(:disabled)": (evt) ->
      $button = $(evt.currentTarget)
      txt = $(snippet).text()
      type = langNotepad.value
  
      if txt isnt ""
        $button.attr("disabled","disabled")
        messagesController.createMessage txt, type, ->
          $button.removeAttr("disabled")
          $button.parents('.show').find("textarea").val("")
  
    'dragenter .file-drop': (evt) ->
      $(evt.currentTarget).addClass('over')
  
    'dragleave .file-drop': (evt) ->
      $(evt.currentTarget).removeClass('over')
  
    'drop .file-drop': (evt) ->
      evt.preventDefault()
      target = evt.currentTarget
      text = $(evt.currentTarget).removeClass('over').find('textarea')
  
      files = evt.dataTransfer.files
      for file in files
        do (file) ->
          reader = new FileReader()
          reader.onload = (readerEvent) ->
            text.val readerEvent.target.result
      
          reader.readAsText(file)  