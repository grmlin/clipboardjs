class RegistrationValidator extends AbstractValidator
  @MIN_NAME_LENGTH: 4
  @MIN_PWD_LENGTH: 6

  username: (data, callback) ->
    isLongEnough = data.length >= RegistrationValidator.MIN_NAME_LENGTH
    Meteor.call "doesUserExist", data, (err, doesExist) =>
      callback.call this, isLongEnough and not doesExist

    isLongEnough

  pwd: (data) ->
    data.length >= RegistrationValidator.MIN_PWD_LENGTH 
    