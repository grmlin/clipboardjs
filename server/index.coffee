Meteor.startup ->
  Meteor.publish "users", (userId) ->
    user = Users.find userId,
      fields:
        pwd: false

    console.log "Publishing user #{userId}"
    return user

  Meteor.publish "streams", (userId) ->
    streams = Streams.find users: userId
    return streams

  Meteor.publish "messages", (userId, streamId) ->
    # Get the corrosponding messages
    messages = Messages.find({
    $or: [
      {$and: [
        {user_id: userId},
        {stream_id: null}
      ]},
      {bookmarked_by: userId},
    ]
    }, {
    fields:
      {
      raw: false
      highlighted: false
      user_id: false
      }
    })

    console.log "publishing #{messages.count()} messages for user #{userId}"
    return messages

  Meteor.publish "streamMessages", (streamId, offset, max) ->
    messages = StreamMessages.find stream_id: streamId
    console.log "publishing #{messages.count()} stream-messages for stream #{streamId}"
    return messages

  Meteor.publish "messageAnnotations", (messageId) ->
    annotations = MessageAnnotations.find({
    message_id: messageId
    },
      {
      fields:
        {
        user_id: false
        }
      })

  Meteor.publish "invitations", (userId) ->
    Invitations.find invitee: userId
