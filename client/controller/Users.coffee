class UsersController
  constructor: ->

  _changeName: (id, name) ->
    Boards.update(
      {user_id: id},
      {$set:
        {user_name: name}
      }, multi: true
    )
    Messages.update(
      {user_id: id},
      {$set:
        {user_name: name}
      }, multi: true
    )
    
  createUser: ->
    localStorage[SESSION_USER] = Users.insert
      user_name: "ANONYMOUS"
      is_registered: false
    @loadUser localStorage[SESSION_USER]

  loadUser: (id) ->
    user = Users.findOne id
    if typeof user isnt "undefined"
      Session.set SESSION_USER, id
    else
      @createUser()

  register: (id, name, pwd) ->
    unless pwd.length < 6 and name.length >= 4 and Users.find({user_name: name}).count() isnt 0
      Meteor.call "getPwHash", pwd, (err, hash) =>
        Users.update(id, $set:
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
        if typeof err is "undefined"
          alert("Username/Password incorrect")
        else
          Users.remove(Session.get(SESSION_USER))
          @loadUser(id) 
        
  logout: ->
    delete localStorage[SESSION_USER]
    location.reload()
    
  updateUser: (id, name) ->
    console?.log "updating user to", name
    Users.update(id, $set:
      {user_name: name})
    