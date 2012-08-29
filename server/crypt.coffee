do ->
  SALT = "asdf09fs809sdfjifs9008sdfjklasfd990823jksdafj"
  require = __meteor_bootstrap__.require
  crypto = require 'crypto'

  getHash = (pwd) ->
    shasum = crypto.createHash 'sha1'
    shasum.update SALT + pwd
    shasum.digest 'hex'

  Meteor.methods
    getPwHash: (pwd) ->
      return getHash pwd

    getUserId: (name, pwd) ->
      user = Users.findOne({user_name: name, is_registered: true})
      if user and user.pwd is getHash pwd
        return user._id
      else
        throw new Meteor.Error(403, "Access Denied")

    canViewBoard: (userId, boardId) ->
      board = Boards.findOne boardId
      not board?.is_private or (userId is board?.user_id)