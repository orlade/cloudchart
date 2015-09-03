Template.Dashboard.rendered = ->

Template.Dashboard.helpers
  services: -> _.values Services

Template.Dashboard.events
  'click a.service': (e) ->
    Router.go('service', {id: @id})
    false
