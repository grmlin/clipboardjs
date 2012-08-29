# TODO clean up this mess 
# TODO Validation class
do ->
  
  Template.user.user = ->
    Users.findOne(Session.get(SESSION_USER))
  
  Template.user.events =
    "keyup .user .name": (evt) ->
      $(evt.currentTarget).parents('.user:first').addClass("changed")
  
    "click .logout": (evt) ->
      usersController.logout()
      
  # TODO add a modal class
    "click .login": (evt) ->
      modal = new Modal(Template.user_create_modal, new LoginValidator())
      modal.submit = (formData) ->
        usersController.login(formData.username, formData.pwd)
        modal.close()
        
      modal.show {title:"Login",user_name: "", submit_text:"Login"}

    "click .create": (evt) ->
      userName = $(evt.currentTarget).parent().prev().find('.name').text()
      
      modal = new Modal(Template.user_create_modal, new RegistrationValidator())
      modal.submit = (formData) ->
        usersController.register(Session.get(SESSION_USER),formData.username, formData.pwd)
        modal.close()

      modal.show {title:"Register",user_name: userName, submit_text:"Register"}
      