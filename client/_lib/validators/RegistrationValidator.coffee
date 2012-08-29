class RegistrationValidator  extends AbstractValidator
  @MIN_NAME_LENGTH : 4
  @MIN_PWD_LENGTH: 6
  
  username: (data) ->
    Users.find({user_name:data}).count() is 0 and data.length >= RegistrationValidator.MIN_NAME_LENGTH
  
  pwd: (data) ->
    data.length >= RegistrationValidator.MIN_PWD_LENGTH 
    