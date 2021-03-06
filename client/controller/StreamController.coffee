class StreamController
  isStream: (streamShortId, callback) ->
    Meteor.call("isStream", streamShortId, (err, isStream) ->
      console?.error err if err
      callback.call this, isStream
    )

  isSubscribed: (streamShortId, userId) ->
    Streams.find({short_id: streamShortId, users: userId}).count() > 0