do ->
  Template.notifications.helpers
    items: ->
      Invitations.find({invitee: Session.get(SESSION_USER)})

    count: (items) ->
      items.count()

  Template.notifications_modal.helpers
    items: ->
      Invitations.find({invitee: Session.get(SESSION_USER)})

  Template.notifications.rendered = ->
    modal = document.getElementById("notifications")
    list = modal.querySelector("ul")
    console.log "LIST: #{list}"
    if list isnt null
      $(modal).modal({backdrop: true, show: false})

  Template.notifications.events =
    'click .show-notifications': (evt) ->
      $('#notifications').modal("toggle")

  Template.notifications_modal.events =
    'click .open': (evt) ->
      #evt.preventDefault()
      $('#notifications').modal("toggle")
      $(evt.currentTarget).next().click()

    'click .remove': (evt) ->
      evt.preventDefault()
      usersController.removeInvitation evt.currentTarget.value