class InviteValidator extends AbstractValidator

  username: (data, callback) ->
    isLongEnough = data.length >= 1
    Meteor.call "doesUserExist", data, (err, doesExist) =>
      callback.call this, isLongEnough and doesExist

    isLongEnough
