do ->
  shortid = meteorNpm.require "shortid"
  
  Meteor.methods
    createStream: (userId) ->
      newid = Streams.insert
        short_id: shortid.generate()
        time: (new Date()).getTime()
        users: [userId]
        owner: userId
    
    joinStream: (streamShortId, userId) ->
      throw new Meteor.Error(404, "Stream not found") if Streams.find(short_id: streamShortId).count() is 0
      Streams.update {short_id: streamShortId}, {$addToSet:
        {users: userId}}
    
    leaveStream: (streamShortId, userId) ->
      throw new Meteor.Error(404, "Stream not found") if Streams.find(short_id: streamShortId).count() is 0
      Streams.update {short_id: streamShortId}, {$pull:
        {users: userId}}
    
    isStream: (streamShortId) ->
      Streams.find({short_id:streamShortId}).count() > 0
      
    isSubscribed: (streamShortId, userId) ->
      Streams.find({short_id: streamShortId, users: userId}).count() > 0