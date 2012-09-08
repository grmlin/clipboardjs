Users.remove = ->
  
UsersController = do() ->
  saveUser = (id) ->
    localStorage[SESSION_USER] = id
    Session.set SESSION_USER, id  
  
  class UsersController
    constructor: ->

    _changeName: (id, name) ->
      messagesController.updateUserName(id, name)

      
    createUser: ->
      Meteor.call "createUser", (err, userId) =>
        if typeof err is "undefined"
          console?.log "created user #{userId}"
          saveUser(userId) 
        else 
          console?.warn "user couldnt be created"

    loadUser: (id) ->
      Meteor.call "loadUser", id, (err, userId) =>
        if typeof err is "undefined"
          console?.log "loaded user "
          saveUser(userId)
        else
          @createUser()
      
    register: (id, name, pwd, callback) ->
      userValidator = new RegistrationValidator()

      if userValidator.validate("pwd", pwd) and userValidator.validate("username", name)
        Meteor.call "registerUser", id, name, pwd, (err, id) =>
          if typeof err is "undefined"
            saveUser id
            @_changeName id, name 
          else
            console?.error err
            alert "Registration failed... #{err.reason}"
            
          callback.call this, err, id

    login: (name, pwd) ->
      userId = Meteor.call "getUserId", name, pwd, (err, id) =>
        if typeof err is "undefined"
          saveUser(id)
        else
          console?.error err
          alert("Username/Password incorrect")

    logout: ->
      delete localStorage[SESSION_USER]
      location.reload()