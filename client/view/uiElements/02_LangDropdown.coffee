class LangDropdown 
  constructor: (@toggle) ->
    @toggle.dropdown()
    
    @button = @toggle.prev()
    @list = @toggle.next()
  
    @list.on 'click', 'li:not(.active) a', @_onLangSelect
    
  _onLangSelect: (evt) =>
    evt.preventDefault()
    @button.text evt.currentTarget.textContent
    @onLangChanged evt.currentTarget.textContent
    $(evt.currentTarget).parent().addClass('active').siblings('.active').removeClass "active"
    
  onLangChanged : (langDescription) ->
    
  getLang: ->
    @list.find('li.active a').attr('data-val')