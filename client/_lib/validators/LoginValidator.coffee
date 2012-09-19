class LoginValidator  extends AbstractValidator
  username: (data) ->
    data.length > 0
  
  #pwd: (data) ->
  #  data.length > 0
    