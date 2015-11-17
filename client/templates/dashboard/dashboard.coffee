Template.dashboard.rendered = ->

Template.dashboard.helpers
  syncing: -> State.syncing
  services: -> _.values Services
  # Stringify the count so "0" is truthy.
  count: -> if @count? then "#{@count}"

Template.dashboard.events
  'click .service.card': (e) ->
    Router.go('service', {id: @id})
    false
