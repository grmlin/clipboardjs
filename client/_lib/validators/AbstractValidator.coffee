class AbstractValidator
  validate: (name, data, callback = ->) ->
    if typeof @[name] is "function"
      return @[name] data, callback
    else
      return null