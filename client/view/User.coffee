# TODO clean up this mess 
# TODO Validation class
do ->
  
  validateUsername = (userName) ->
    Users.find({user_name:userName}).count() is 0 and userName.length >= 4
  
  setSaveButton = ($modal) ->
    if $modal.find(".error").length > 0
      $modal.find(".save").attr("disabled","disabled")
    else
      $modal.find(".save").removeAttr("disabled")

  Template.user.user = ->
    Users.findOne(Session.get(SESSION_USER))
  
  Template.user.events =
    "keyup .user .name": (evt) ->
      $(evt.currentTarget).parents('.user:first').addClass("changed")
  
    "click .logout": (evt) ->
      usersController.logout()
      
  # TODO add a modal class
    "click .login": (evt) ->
      $modal = $ Template.user_create_modal({title:"Login",user_name: "", submit_text:"Login"})
      $nameInputWrapper = $modal.find ".username"
      $pwdInputWrapper = $modal.find ".pwd"

      $modal.on "click", ".cancel, .close", =>
        $modal.remove()

      $modal.on "click","button.save:not(:disabled)", ->
        name = $nameInputWrapper.find("input").val()
        pwd = $pwdInputWrapper.find("input").val()
        usersController.login(name, pwd)
        $modal.remove()
        
      $('body').append $modal
      $modal.removeClass "hide fade"


    "click .create": (evt) ->
      userName = $(evt.currentTarget).parent().prev().find('.name').text()
      $modal = $ Template.user_create_modal({title:"Register",user_name: userName, submit_text:"Register"})
      $nameInputWrapper = $modal.find ".username"
      $pwdInputWrapper = $modal.find ".pwd"
      
      $modal.on "keyup","[name=username]", (event) =>
        $nameInputWrapper.removeClass("error success")
        state = if validateUsername(event.target.value) then "success" else "error"
        $nameInputWrapper.addClass(state)
        setSaveButton($modal)

      $modal.on "keyup","[name=pwd]", (event) =>
        $pwdInputWrapper.removeClass("error success")
        state = if event.target.value.length >= 6 then "success" else "error"
        $pwdInputWrapper.addClass(state)
        setSaveButton($modal)

      $modal.on "click", ".cancel, .close", =>
        $modal.remove()
    
      $modal.on "click","button.save:not(:disabled)", ->
        name = $nameInputWrapper.find("input").val()
        pwd = $pwdInputWrapper.find("input").val()
        
        usersController.register(Session.get(SESSION_USER),name, pwd)
        $modal.remove()

      $('body').append $modal
      $modal.removeClass "hide fade"
  
      $modal.find("[name=username]").trigger("keyup")
      $modal.find("[name=pwd]").trigger("keyup")
      
      $modal.on "click", ".save", =>
        
