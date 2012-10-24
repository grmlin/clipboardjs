UsersController = do() ->
  class UsersController
    constructor: ->

    getUserId: ->
      Meteor.userId() ? @getTempUserId()

    getTempUserId: ->
      Session.get(SESSION_TEMP_USER_ID)

    removeInvitation: (id) ->
      Meteor.call("removeInvitation", id, Meteor.userId(), (err, res) ->
        console?.error(err) if err
      )