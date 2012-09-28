class CommentValidator  extends AbstractValidator
  comment: (data) ->
    data.length > 0
