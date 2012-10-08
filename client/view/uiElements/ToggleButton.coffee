class ToggleButton 
  constructor: (@name, @button, @parent) ->
    @toggledClass = "#{@name}-toggled"
    
    @parent.removeClass @toggledClass
    @button.on 'click', @onClick
    
  onClick: (evt) =>
    evt.preventDefault()
    
    @button.toggleClass "btn-success"
    @button.children('i').toggleClass "icon-white"
    @parent.toggleClass @toggledClass
