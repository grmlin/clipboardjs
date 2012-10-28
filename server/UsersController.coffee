do() ->
  Meteor.methods
    invite: (userName, byUserId, fragment) ->
      invitee = Meteor.users.findOne({username: userName})
      inviter = Meteor.users.findOne(byUserId)
      throw new Meteor.Error(404, "Invite failed") unless invitee
      
      desc = "stream" if fragment.indexOf("stream") isnt -1
      desc = "message" if fragment.indexOf("message") isnt -1
      desc = "something" if typeof desc is "undefined"
      
      Invitations.insert
        invitee: invitee._id
        inviter: inviter and inviter.username ? "<unregistered user>"
        fragment: fragment
        description: desc

    removeInvitation: (id, userId) ->
      Invitations.remove({
        _id: id,
        invitee: userId
      })                
