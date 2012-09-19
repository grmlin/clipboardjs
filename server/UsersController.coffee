do() ->
  checkUser: (userId) ->
    interval = Meteor.setInterval(=>
      now = (new Date()).getTime()
      user = Users.findOne userId
      if now - user.last_beat > 30 * 1000
        Users.update(userId,
          $set: connected = false)
    , 6 * 1000)

  Meteor.methods
    heartBeat: (userId) ->
      user = Users.findOne(userId)
      user.last_beat = (new Date()).getTime()



    createUser: ->
      userId = Users.insert
        is_connected: false
        is_registered: false
        last_beat: 0
        time: (new Date()).getTime()
        user_name: "ANONYMOUS"

      console.log "created user #{userId}"

      return userId

    loadUser: (id) ->
      user = Users.findOne id
      throw new Meteor.Error(404, "User not found") if typeof user is "undefined"

      console.log "loaded user #{user.user_name}"

      return user._id

    registerUser: (id, name, pwd) ->
      existing = Users.findOne({user_name: name, is_registered: true})
      throw new Meteor.Error(404, "User already exists") if typeof existing isnt "undefined"

      user = Users.findOne id
      throw new Meteor.Error(404, "User not found") if typeof user is "undefined"


      Users.update id,
        $set:
          user_name: name
          pwd: Meteor.call "getPwHash", pwd
          is_registered: true

      console.log "registered user #{user.user_name}"

      return user._id

    getUser: (id) ->
      existing = Users.findOne(id)
      throw new Meteor.Error(404, "User not there") if typeof existing is "undefined"
      return existing

    doesUserExist: (username) ->
      Users.find(user_name: username).count() > 0

    invite: (userName, byUserId, fragment) ->
      invitee = Users.findOne({user_name: userName})
      inviter = Users.findOne(byUserId)
      throw new Meteor.error(404, "Invite failed") unless invitee and inviter
      
      Invitations.insert
        invitee: invitee._id
        inviter: inviter.user_name
        fragment: fragment
