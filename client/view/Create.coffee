do ->
  snippet = null
  hightlighted = null
  langNotepad = null
  dropdown = null
  
  Template.create.helpers
    show : ->
      appState.isState appState.LIST
  
  Template.create.rendered = ->
    snippet = this.find ".text-board"
    hightlighted = this.find ".prettyprint code"
    langNotepad = this.find '[name="current-lang-notepad"]'
    dropdown = new LangDropdown($(this.find('.language-toggle')))
    dropdown.onLangChanged = (langDescription) =>
      this.find('.current-lang-preview').textContent = langDescription
      
    $('.tooltip').remove()
    $(this.findAll('.preview')).tooltip()
    
  #TODO use LangDropdown class 
  Template.create.events =
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
      type = dropdown.getLang()

      if txt isnt ""
        $button.attr("disabled", "disabled")
        messagesController.createMessage txt, type, ->
          $button.removeAttr("disabled")
          $button.parents('.show').find(".text-board").html("")