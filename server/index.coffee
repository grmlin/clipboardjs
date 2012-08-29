Meteor.startup ->
  Meteor.publish "boards", ->
    Boards.find({}, {
    fields:
      {
      #user_id: false
      }
    })

  Meteor.publish "users", ->
    Users.find({}, {
    fields:
      {
      pwd: false
      }
    })
    
  Meteor.publish "messages", ->
    Messages.find({}, {
      fields:
        {
          message: false
        }
    })
