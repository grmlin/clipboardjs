do ->
  DELAY = 100
  
  Template.loading_notifications.helpers
    items: ->
      loadingIndicator.getLoadingItems()

    has_items: (items) ->
      items.length > 0

    hint: (item) ->
      item

  Template.loading_notifications.rendered = ->
    Meteor.setTimeout =>
      $(this.find('div')).addClass("visible")
    , DELAY