Publisher =
  wirePublications: ->
    Meteor.publish "users", (userId) ->
      user = Users.find userId,
        fields:
          pwd: false
  
      console.log "Publishing user #{userId}"
      return user
  
    Meteor.publish "streams", (userId, pageNumber = 1, nPerPage = 10) ->
      streams = Streams.find({users: userId},{
        skip: (pageNumber - 1) * nPerPage
        limit: nPerPage
      })
      console.log "skipping #{(pageNumber - 1) * nPerPage}"
      console.log "limit #{nPerPage}"
      console.log("Publishing #{streams.fetch().length}/#{Streams.find().count()} streams, page: ", pageNumber," n: ", nPerPage)

      return streams
  
    Meteor.publish "messages", (userId, pageNumber = 1, nPerPage = 10) ->
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
        raw: false
        highlighted: false
        user_id: false
      sort:
        time: -1
      skip: (pageNumber - 1) * nPerPage
      limit: nPerPage
      })
  
      console.log "publishing #{messages.count()} messages for user #{userId}"
      return messages
  
    Meteor.publish "current_message", (messageId) ->
      messages = Messages.find({short_id: messageId},
        {
        fields:
          user_id: false
        })
      return messages
      
    Meteor.publish "current_stream", (streamid) ->
      streams = Streams.find({short_id: streamid},
        {
        })
      return streams
  
    Meteor.publish "stream_messages", (streamId, offset, max) ->
      messages = Messages.find stream_id: streamId
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
  
  
    sleep = (s) ->
      e = new Date().getTime() + (s * 1000);
      nthg() while (new Date().getTime()) <= e
  
    nthg = ->