do ->
  reactiveList = () ->
    Meteor.renderList(
      Invitations.find({invitee: Session.get(SESSION_USER)})
    , (invitation) ->
      return Template.notification_item(invitation)
    , ->
      return ""#Template.notification_item()
    )

  Template.notifications.helpers
    items: ->
      Invitations.find({invitee: Session.get(SESSION_USER)})

    count: (items) ->
      items.count()

  Template.notifications.rendered = ->
    $('#notifications').modal({backdrop: false, show: false})
    list = document.getElementById("notifications").querySelector("ul")
    list.innerHTML = ""
    list.appendChild reactiveList()

  Template.notifications.events =
    'click .show-notifications': (evt) ->
      $('#notifications').modal("toggle")
#$('#notifications').toggleClass('in')
