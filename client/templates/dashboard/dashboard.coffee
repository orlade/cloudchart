Template.Dashboard.rendered = ->

Template.Dashboard.helpers
  syncing: -> State.syncing
  services: -> _.values Services
  # Stringify the count so "0" is truthy.
  count: -> if @count? then "#{@count}"

Template.Dashboard.events
  'click a.service': (e) ->
    Router.go('service', {id: @id})
    false

  'click .sync.button': (e) -> Meteor.call 'sync'
