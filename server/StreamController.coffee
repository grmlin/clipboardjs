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
    
    deleteStream: (streamShortId, userId) ->
      stream = Streams.findOne({short_id: streamShortId})
      if stream and userId is stream.owner
        Messages.remove({stream_id: stream.short_id})
        Streams.remove(stream._id)
      else
        throw new Meteor.error(404, "Stream couldn't be deleted")
    
    isStream: (streamShortId) ->
      Streams.find({short_id:streamShortId}).count() > 0
      
    isSubscribed: (streamShortId, userId) ->
      Streams.find({short_id: streamShortId, users: userId}).count() > 0