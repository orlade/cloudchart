Template.navbar.helpers
  syncing: ->
    console.debug @, arguments
    State.syncing

  active: (routeName) -> "active" if Router.current().route.getName() == routeName

Template.navbar.events
  'click a.page.item': (e) ->
    Router.go e.currentTarget.href
    false

  'click .sync.button': (e) -> Meteor.call 'sync'
