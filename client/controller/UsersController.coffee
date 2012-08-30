UsersController = do() ->
  remove = Users.remove
  doRemove = ->
    remove.apply Users, arguments
    
  insert = Users.insert
  doInsert = ->
    insert.apply Users, arguments

  update = Users.update
  doUpdate = ->
    update.apply Users, arguments

  Users.remove = ->
  Users.insert = ->
  Users.update = ->

  class UsersController
    constructor: ->

    _changeName: (id, name) ->
      boardsController.updateUserName(id, name)
      messagesController.updateUserName(id, name)

    createUser: ->
      @loadUser doInsert
        user_name: "ANONYMOUS"
        is_registered: false

    loadUser: (id) ->
      user = Users.findOne id
      if typeof user isnt "undefined"
        localStorage[SESSION_USER] = id
        Session.set SESSION_USER, id
      else
        @createUser()

    register: (id, name, pwd) ->
      userValidator = new RegistrationValidator()

      if userValidator.validate("pwd", pwd) and userValidator.validate("username", name)
        Meteor.call "getPwHash", pwd, (err, hash) =>
          doUpdate(id, $set:
            {
            user_name: name
            pwd: hash
            is_registered: true
            })
          @_changeName(id, name)

    login: (name, pwd) ->
      user = Users.findOne(Session.get(SESSION_USER))
      unless user.is_registered
        userId = Meteor.call "getUserId", name, pwd, (err, id) =>
          if typeof err isnt "undefined"
            alert("Username/Password incorrect")
          else
            doRemove(Session.get(SESSION_USER))
            @loadUser(id)

    logout: ->
      delete localStorage[SESSION_USER]
      location.reload()

    updateUser: (id, name) ->
      console?.log "updating user to", name
      doUpdate(id, $set:
        {user_name: name})
      