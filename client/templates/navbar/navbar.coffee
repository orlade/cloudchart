_initDropdown = ->
  $('.dropdown').dropdown({on: 'hover', action: 'hide'})

Template.navbar.onRendered -> _initDropdown()
Accounts.onLogin ->
  # Ensure the dropdown has been initialized for the new current user.
  Tracker.flush()
  _initDropdown()

Template.navbar.helpers
  syncing: -> _.reduce Services, ((z, s) -> z + (State["#{s.id}Syncing"] ? 0)), 0
  syncingName: ->
    for id, {name} of Services
      if State["#{id}Syncing"] then return name
  active: (routeName) -> "active" if Router.current().route.getName() == routeName

Template.navbar.events
  'click a.page.item': (e) ->
    Router.go e.currentTarget.href
    false

  'click .sync.button': ->
    log.debug "Syncing all services..."
    Meteor.call 'sync', (err, res) -> log.error err if err

  'click .logout': ->
    if confirm 'Are you sure you want to logout?'
      Meteor.logout()
      Router.go 'home'
