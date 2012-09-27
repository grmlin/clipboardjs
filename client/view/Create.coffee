do ->
  snippet = null
  hightlighted = null
  langNotepad = null

  Template.create.helpers
    show : ->
      appState.isState appState.LIST
  
    user_name : ->
      Boards.findOne(Session.get(SESSION_BOARD_ID))?.user_name

  Template.create.rendered = ->
    snippet = this.find ".text-board"
    hightlighted = this.find ".prettyprint code"
    langNotepad = this.find '[name="current-lang-notepad"]'

    $('.tooltip').remove()
    $(this.findAll('.preview')).tooltip()
    
  #TODO use LangDropdown class 
  Template.create.events =
    'click .text-type .dropdown-menu li:not(.active) a': (evt) ->
      $lang = $(evt.currentTarget)
      $view = $lang.parents('.show:first')
      lang = evt.currentTarget.getAttribute "data-val"
      langDesc = evt.currentTarget.innerHTML

      $lang.parents('ul:first').children('.active').removeClass('active')
      $lang.parent().addClass "active"

      $view.find('.current-lang').html(langDesc)

      langNotepad.value = lang
      
      if $view.hasClass "previewed"
        $view.find('.preview:first').click().click() #hrrrr

    'click .preview': (evt) ->
      $button = $ evt.currentTarget
      $view = $button.parents '.show:first'
      
      $button.toggleClass "btn-success"
      $button.children('i').toggleClass("icon-white")
      $view.toggleClass "previewed"
      
      isPreviewed = $view.hasClass "previewed"

      if isPreviewed and $(snippet).text() isnt ""
        preview = null
        txt = HtmlEncoder.encode($(snippet).text())
        
        switch langNotepad.value
          when "auto"
            try
              preview = hljs.highlightAuto txt
          when "plain"
            preview = null
          else
            try
              preview = hljs.highlight langNotepad.value, txt

        if preview
          hightlighted.innerHTML = preview.value
          $view.find('.current-computed-lang').text preview.language
        else
          hightlighted.innerHTML = txt
          $view.find('.current-computed-lang').text("plain")
       else
        hightlighted.innerHTML = ""
        
    'paste .text-board': (evt) ->
      window.setTimeout =>
        s = new Sanitize()
        clean = document.createElement "div"
        clean.style.whiteSpace = "pre" 
        clean.appendChild s.clean_node(snippet)
        snippet.innerHTML = clean.innerHTML
        clean = null
      , 5

    "click .paste-text-board:not(:disabled)": (evt) ->
      $button = $(evt.currentTarget)
      txt = $(snippet).text()
      type = langNotepad.value

      if txt isnt ""
        $button.attr("disabled", "disabled")
        messagesController.createMessage txt, type, ->
          $button.removeAttr("disabled")
          $button.parents('.show').find(".text-board").html("")