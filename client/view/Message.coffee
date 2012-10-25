do ->
  inviteModal = new InviteModal()

  messageObserver = null
  annotationObserver = null
  refreshTimeout = null

  commentPopover = null

  Template.message_view.helpers
    show: ->
      messageId = Session.get(SESSION_SHORT_MESSAGE_ID)
      isRightState = appState.getState() is appState.MESSAGE
      isMessageSelected = messageId isnt ""

      isRightState and isMessageSelected

    show_editor: ->
      Meteor.userId() isnt null
      
    message: ->
      messageId = Session.get(SESSION_SHORT_MESSAGE_ID)
      message = Messages.findOne({short_id: messageId})

      if message and message.raw and message.highlighted
        return message
      else 
        return null
        
    raw: (message) ->
      return HtmlEncoder.encode(message.raw)

    annotated: (message) ->
      toChange = {}
      letters = message.raw.split("")
      annotations = MessageAnnotations.find(message_id: Session.get(SESSION_SHORT_MESSAGE_ID))
      annotations.forEach((ann) ->
        annotated = letters.slice(ann.start, ann.end)
        letters.forEach((item, index) ->
          isAnnotated = index >= ann.start and index < ann.end
          if typeof toChange[index] isnt "undefined" and isAnnotated
            toChange[index].push(ann)
          else if isAnnotated
            toChange[index] = [ann]
        )
      )

      letters.forEach((item, index) ->
        letters[index] = HtmlEncoder.encode(letters[index])
        if typeof toChange[index] isnt "undefined"
          marker = ""
          marker += "<span data-annotation='#{annotation._id}'></span>" for annotation in toChange[index]
          letters[index] = "<span class='annotation' title='#{toChange[index].length} comment#{if toChange[index].length > 1 then "s" else ""}'>#{letters[index]}#{marker}</span>"
      )

      return letters.join("")

  Template.message_view.rendered = ->
    messageId = Session.get(SESSION_SHORT_MESSAGE_ID)
    view = this.find '.message-view'
    commentButton = new ToggleButton("comments", $(this.find('.comments-toggle')), $('#content'))

    view?.className = view.className.replace "editing", ""

    $('.tooltip').remove()
    $(this.findAll('.view-toolbar .btn, .message-editor .btn-group')).tooltip()

  Template.message_view.events =
    'click .share': (evt) ->
      evt.preventDefault()
      url = window.location
      inviteModal.show
        url: url

    "click .raw": (evt) ->
      message = Messages.findOne({short_id: Session.get(SESSION_SHORT_MESSAGE_ID)})
      raw = $ Template.message_raw({raw: message.raw})
      $('body').append(raw)
      $('body').children('.app').hide()

      $('.raw-file .close').click(->
        raw.remove()
        $('body').children('.app').show()
      )

    'click .edit': (evt) ->
      button = $(evt.currentTarget)
      toolbar = button.parents('.view-toolbar')

      button.toggleClass("btn-success")
      button.parent().toggleClass("editing")
      button.children("i").toggleClass("icon-white")
      toolbar.find('.message-editor').toggleClass("editing")
      toolbar.nextAll('.message-annotations').toggle(150)
      toolbar.nextAll('.message-view').toggleClass("editing")

      selection = window.getSelection();
      if (selection.rangeCount > 0)
        window.getSelection().removeAllRanges();

    'click .login-proxy': (evt) ->
      document.querySelector('#login-buttons .login-link-text').click()
      
    'click .add-annotation': (evt) ->
      selection = window.getSelection();
      if selection.rangeCount > 0
        range = selection.getRangeAt(0)
        node = $(range.startContainer).parents('code:first')

        if node.length > 0
          start = range.startOffset
          end = range.endOffset
          modal = new Modal(Template.annotate_modal, new CommentValidator())
          modal.submit = (formData) ->
            messagesController.addAnnotation(Session.get(SESSION_SHORT_MESSAGE_ID),start,end,formData.comment)
            modal.close()

          modal.show {title: "Login", user_name: "", submit_text: "Login"}
      else
        alert "Pleas select some text to annotate, first!"
    'mouseenter .message-annotations ol li': (evt) ->
      clicked = $(evt.currentTarget)
      code = clicked.parents('.message-annotations:first').nextAll('.message-view').find('.code-annotated')

      id = evt.currentTarget.id

      code.find('span.hovered').removeClass("hovered")
      code.find("[data-annotation=#{id}]").parent().addClass("hovered")

    'mouseleave .message-annotations ol li': (evt) ->
      clicked = $(evt.currentTarget)
      code = clicked.parents('.message-annotations:first').nextAll('.message-view').find('.code-annotated')

      code.find('span.hovered').removeClass("hovered")

    'click .message-annotations ol li': (evt) ->
      clicked = $(evt.currentTarget)
      code = clicked.parents('.message-annotations:first').nextAll('.message-view').find('.code-annotated')

      id = evt.currentTarget.id

      clicked.siblings('.active').removeClass("active")
      clicked.toggleClass("active")
      code.find('span.hovered').removeClass("hovered")
      code.find('span.active').removeClass("active")
      code.find("[data-annotation=#{id}]").parent().addClass("active") if clicked.hasClass('active')

    'click .annotation:not(.active)': (evt) ->
      evt.stopPropagation()

      annotations = []
      clicked = $(evt.currentTarget)
      code = clicked.parent()

      commentPopover?.popover('hide')
      commentPopover = clicked

      clicked.children('span').each(->annotations.push(this.getAttribute("data-annotation")))

      code.find('span.active').removeClass("active")
      annotations.forEach((a)->
        code.find("[data-annotation=#{a}]").parent().addClass("active")
      )                               

      clicked
        .popover({content: Template.comment_popover(MessageAnnotations.find(_id:
          {$in: annotations})), placement: 'bottom'})
        .popover('show')

      $('html').off("click.comment_popover").on("click.comment_popover", (evt)->
        outsider = $ evt.target
        unless outsider.hasClass('.popover') or outsider.parents('.popover').length > 0
          clicked.popover('hide')
          code.find('span.active').removeClass("active")

        isFirst = no
      )

    'mouseenter .annotation': (evt) ->
      annotations = []
      clicked = $(evt.currentTarget)
      code = clicked.parent()

      clicked.children('span').each(->
        annotations.push(this.getAttribute("data-annotation"))
      )

      code.find('span.hovered').removeClass("hovered")
      annotations.forEach((a)->
        code.find("[data-annotation=#{a}]").parent().addClass("hovered")
      )

    'mouseleave .annotation': (evt) ->
      clicked = $(evt.currentTarget)
      code = clicked.parent()

      code.find('span.hovered').removeClass("hovered")

    "click .message-view:not(.editing) .prettyprint code": (evt) ->
      ###if document.selection
        range = document.body.createTextRange()
        range.moveToElementText(evt.currentTarget)
        range.select()
      else if window.getSelection
        range = document.createRange()
        range.selectNode(evt.currentTarget)
        window.getSelection().addRange(range)
      ###