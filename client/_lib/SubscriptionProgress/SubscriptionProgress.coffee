SubscriptionProgress = do ->
  SESSION_KEY = "subscription_loader_loads"
  uid = 0


  class SubscriptionLoader
  # static
    @subscriptions: []
    @getLoadingItems: ->
      items = []
      for own key, type of LoadingIndicator.types
        items.push(type.hint) if @isLoading(type)

      return items

    # instance
    constructor: () ->
      @_uid = uid++;
      @_subscriptions = {}

    addSubscription: (getArgs) ->
      Meteor.autosubscribe =>
        getArgs(() =>
          subscribeArguments = Array.prototype.slice.call(arguments)
          name = _.first(subscribeArguments)
          cb = _.last(subscribeArguments)

          if typeof cb is "function"
            subscribeArguments = _.initial subscribeArguments
          else
            cb = ->

          args = subscribeArguments.concat([=>
            @_onLoadComplete(_.first(subscribeArguments))
            cb.apply @
          ])

          @_subscriptions[name] = true
          @_onBeforeLoad(name)
          Meteor.subscribe.apply(Meteor.subscribe, args)
        )

    isLoading: () ->
      isLoading = false
      for own name, type of @_subscriptions
        if @isSubscriptionLoading(name)
          console.log name, "''''''LLLOOOOAAADDDSSS''''''"
          isLoading = true
          break

      return isLoading

    isSubscriptionLoading: (name) ->
      @_getLoadState name

    getLoadingItems: ->
      items = []
      for own name, type of @_subscriptions
        items.push(name) if @isSubscriptionLoading(name)

      return items

    #private
    _getKey: (name) ->
      "#{SESSION_KEY}_#{name}_#{@_uid}"

    _setLoadState: (name, isLoading) ->
      Session.set @_getKey(name), isLoading

    _getLoadState: (name) ->
      Session.get @_getKey(name)

    _onBeforeLoad: (name) ->
      @_setLoadState name, true
      console?.log "####LOADER#### Subscription \"#{name}\" loads new data now "

    _onLoadComplete: (name) =>
      @_setLoadState name, false
      console?.log "####LOADER#### Subscription \"#{name}\" was sucessfully refreshed "