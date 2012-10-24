class InviteModal extends Modal
  constructor: () ->
    super Template.invite_modal, new InviteValidator()
    
  submit: (data) ->
    super data
    console.log Backbone.history.fragment
    Meteor.call("invite", data.username, Meteor.userId(), Backbone.history.fragment, (err,invite) =>
      console?.error(err) if err
      console?.log "invitation created: #{invite}"
      @close()
    )
    