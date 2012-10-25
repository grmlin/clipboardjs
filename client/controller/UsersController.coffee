UsersController = do() ->
  class UsersController
    constructor: ->
      checkUser = =>
        ctx = new Meteor.deps.Context()
        ctx.on_invalidate(checkUser)
        ctx.run =>
          userId = Meteor.userId()
          unless userId is null
            @updateUserName(@getTempUserId(), userId)

      checkUser()
      
    getUserId: ->
      Meteor.userId() ? @getTempUserId()

    getTempUserId: ->
      Session.get(SESSION_TEMP_USER_ID)

    removeInvitation: (id) ->
      Meteor.call("removeInvitation", id, Meteor.userId(), (err, res) ->
        console?.error(err) if err
      )

    updateUserName: (oldId, newId) ->
      Meteor.call "updateMessageOwner", oldId, newId, (err, res) ->
        console?.log err, res