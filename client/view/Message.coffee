do ->
  inviteModal = new InviteModal()

  messageObserver = null
  annotationObserver = null
  refreshTimeout = null

  Template.message_view.helpers
    show: ->
      messageId = Session.get(SESSION_SHORT_MESSAGE_ID)
      isRightState = appState.getState() is appState.MESSAGE
      isMessageSelected = messageId isnt ""

      isRightState and isMessageSelected

    message: ->
      Messages.findOne({short_id: Session.get(SESSION_SHORT_MESSAGE_ID)})

    is_bookmarked: (messageId) ->
      userId = Session.get SESSION_USER
      Messages.find({_id: messageId, bookmarked_by: userId}).count() > 0

  Template.message_view.rendered = ->
    refresh = ->
      Meteor.clearTimeout(refreshTimeout)
      refreshTimeout = Meteor.setTimeout(->
        console?.log "refreshing message view"
        if view or $(view).hasClass("loading")
          Meteor.call "getMessage", messageId, Session.get(SESSION_USER), (err, message) =>
            view.className = view.className.replace "loading", ""
            if typeof err is "undefined"
              view.innerHTML = Template.message_detail(message)
            else
              console.log err
              view.innerHTML = Template.message_detail_unavailable()
      , 250)
      
    view = this.find '.message-view'
    view?.className = view.className.replace "editing", ""

    $('.tooltip').remove()
    $(this.findAll('.view-toolbar .btn, .message-editor .btn-group')).tooltip()
    messageId = Session.get(SESSION_SHORT_MESSAGE_ID)

    messageQuery = Messages.find({short_id: messageId})
    annotationQuery = MessageAnnotations.find(message_id: messageId)

    messageObserver.stop() unless messageObserver is null
    annotationObserver.stop() unless annotationObserver is null

    if messageQuery
      messageObserver = messageQuery.observe(
        added: (message) ->
          refresh()
        removed: ->
          refresh()
      )
    if annotationQuery
      annotationObserver = annotationQuery.observe(
        added: (message) ->
          refresh()
        changed: () ->
          refresh()
      ) 

  Template.message_detail.helpers
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
          letters[index] = "<span class='annotation'>#{letters[index]}#{marker}</span>"
      )

      return letters.join("")

  Template.message_view.events =
    'click .share': (evt) ->
      evt.preventDefault()
      url = window.location
      inviteModal.show
        url: url

    "click .raw": (evt) ->
      messagesController.getRawMessage(Session.get(SESSION_SHORT_MESSAGE_ID), (message) ->
        raw = $ Template.message_raw({message: message})
        $('body').append(raw)
        $('body').children('.app').hide()

        $('.raw-file .close').click(->
          raw.remove()
          $('body').children('.app').show()
        )
      )

    'click .add-bookmark': (evt) ->
      messageId = Session.get SESSION_SHORT_MESSAGE_ID
      messagesController.addBookmark messageId

    'click .remove-bookmark': (evt) ->
      messageId = Session.get SESSION_SHORT_MESSAGE_ID
      messagesController.deleteBookmark messageId

    'click .edit': (evt) ->
      button = $(evt.currentTarget)
      toolbar = button.parents('.view-toolbar')
      
      button.toggleClass("btn-success")
      button.parent().toggleClass("editing")
      button.children("i").toggleClass("icon-white")
      toolbar.find('.message-editor').toggleClass("editing")
      toolbar.nextAll('.message-view').toggleClass("editing")
      
      selection = window.getSelection();
      if (selection.rangeCount > 0)
        window.getSelection().removeAllRanges();

    'click .add-annotation': (evt) ->
      selection = window.getSelection();
      if selection.rangeCount > 0
        range = selection.getRangeAt(0)
        node = $(range.startContainer).parents('code:first')

        if node.length > 0
          start = range.startOffset
          end = range.endOffset
          Meteor.call("addAnnotation", Session.get(SESSION_SHORT_MESSAGE_ID), Session.get(SESSION_USER), start, end, (err, aId)->
            console?.error(err) if err
          )
          console.dir range
      else
        alert "Pleas select some text to annotate, first!"
          
    'click .annotation': (evt) ->
      annotations = []
      clicked = $(evt.currentTarget)
      list = clicked.parents('.message-view:first').prevAll('.message-annotations:first')
      code = clicked.parent()
      
      clicked.children('span').each(->
        annotations.push(this.getAttribute("data-annotation"))
      )
      cursor = MessageAnnotations.find({_id:{$in:annotations}})

      code.find('span.active').removeClass("active")
      annotations.forEach((a)->
        code.find("[data-annotation=#{a}]").parent().addClass("active")
      )
      list.html(Template.message_annotations(cursor))
      
      console.log cursor.fetch()
      
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