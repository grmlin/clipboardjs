# TODO clean up this mess 
# TODO Validation class
do ->
  Template.user.helpers
    show: ->
      Session.get SESSION_USER

    user: ->
      Users.findOne(Session.get(SESSION_USER))

  Template.user.rendered = ->
    $(this.findAll('.user-drop')).dropdown()
    
  Template.user.events =
    "click .logout": (evt) ->
      usersController.logout()

    # TODO add a modal class
    "click .login": (evt) ->
      modal = new Modal(Template.user_create_modal, new LoginValidator())
      modal.submit = (formData) ->
        usersController.login(formData.username, formData.pwd)
        modal.close()

      modal.show {title: "Login", user_name: "", submit_text: "Login"}

    "click .create": (evt) ->
      userName = $(evt.currentTarget).parents(".user").find('.name').text()

      modal = new Modal(Template.user_create_modal, new RegistrationValidator())
      modal.submit = (formData) ->
        usersController.register(Session.get(SESSION_USER), formData.username, formData.pwd, (err, id) =>
          if typeof err is "undefined"
            modal.close()
          else

        )

      modal.show {title: "Register", user_name: userName, submit_text: "Register"}
      