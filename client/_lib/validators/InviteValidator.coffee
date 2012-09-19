class InviteValidator extends AbstractValidator

  username: (data, callback) ->
    isLongEnough = data.length >= RegistrationValidator.MIN_NAME_LENGTH
    Meteor.call "doesUserExist", data, (err, doesExist) =>
      callback.call this, isLongEnough and doesExist

    isLongEnough
