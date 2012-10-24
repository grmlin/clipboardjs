Meteor.startup ->
  Publisher.wirePublications()

  conntected = () ->
    #console.log "default server:"
    #console.log Meteor.default_server.stream_server.all_sockets()
    #console.log Meteor.users.find().fetch()[0]
    #console.log Meteor.user()

  Meteor.setTimeout(conntected, 5000)