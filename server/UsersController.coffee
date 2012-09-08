do() ->
  Meteor.methods
    createUser: ->
      userId = Users.insert
        time: (new Date()).getTime()
        user_name: "ANONYMOUS"
        is_registered: false
      
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
