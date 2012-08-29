class AbstractValidator
  validate: (name, data) ->
    if typeof @[name] is "function"
      return @[name] data
    else
      return null