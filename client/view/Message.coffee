do ->
  lastMessage = ""

  inviteModal = new InviteModal()

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
    view = this.find '.message-view'
    $('.tooltip').remove()
    $(this.findAll('.message-actions .btn')).tooltip()
    messageId = Session.get(SESSION_SHORT_MESSAGE_ID)

    if (view and lastMessage isnt messageId) or $(view).hasClass("loading")
      lastMessage = messageId

      Meteor.call "getMessage", messageId, Session.get(SESSION_USER), (err, message) =>
        view.className = "message-view"
        if typeof err is "undefined"
          view.innerHTML = Template.message_detail(message)
        else
          console.log err
          view.innerHTML = Template.message_detail_unavailable()

  Template.message_detail.helpers
    annotated: (message) ->
      pattern = /(.)/gm
      toChange = {}
      letters = message.raw.split("")
      annotations = MessageAnnotations.find(message_id: Session.get(SESSION_SHORT_MESSAGE_ID))
      annotations.forEach((ann) ->
        annotated = letters.slice(ann.start, ann.end)
        letters.forEach((item, index) ->
          toChange[index] = toChange[index] or (index >= ann.start and index < ann.end)
        )
      )

      letters.forEach((item,index) ->
        if toChange[index]
          letters[index] = item.replace(pattern,"<span title='Annotated'>$1<span></span></span>")  
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
      button.toggleClass("btn-success")
      button.children("i").toggleClass("icon-white")
      button.parents('.view-toolbar').nextAll('.message-editor').toggle(100).nextAll('.message-view').toggleClass("editing")
      selection = window.getSelection();
      if (selection.rangeCount > 0) 
        window.getSelection().deleteFromDocument();
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