Meteor.startup ->
  Meteor.publish "users", (userId) ->
    user = Users.find userId,
      fields:
        pwd: false

    console.log "Publishing user #{userId}"
    return user

  Meteor.publish "messages", (userId) ->
    messages = Messages.find({
    $or: [
      {user_id: userId},
      {bookmarked_by: userId}
    ]
    }, {
    fields:
      {
      raw: false
      highlighted: false
      }
    })
    console.log "publishing #{messages.count()} messages for user #{userId}"
    return messages

