do ->
  SALT = "asdf09fs809sdfjifs9008sdfjklasfd990823jksdafj"
  require = __meteor_bootstrap__.require
  crypto = require 'crypto'

  getHash = (pwd) ->
    shasum = crypto.createHash 'sha1'
    shasum.update SALT + pwd
    shasum.digest 'hex'

  Meteor.methods
    canViewBoard: (userId, boardId) ->
      board = Boards.findOne boardId
      not board?.is_private or (userId is board?.user_id)