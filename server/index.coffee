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
    # Get all messages streams for this user
    streams = _.map(Streams.find({short_id: streamId, users: userId}).fetch(), (stream) -> return stream.short_id)
    
    console.log "streams found for #{userId}/#{streamId}:", streams
    
    # Get the corrosponding messages
    messages = Messages.find({
    $or: [
      {$and : [{user_id: userId},{stream_id:null}]},
      {bookmarked_by: userId},
      {stream_id:{$in:streams}}
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

