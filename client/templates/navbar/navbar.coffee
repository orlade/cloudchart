Template.navbar.helpers
  active: (routeName) -> "active" if Router.current().route.getName() == routeName

Template.navbar.events
  'click a.page.item': (e) ->
    Router.go e.currentTarget.href
    false

  'click .sync.button': -> Meteor.call 'sync'

  'click .login': -> AccountsUi.goToLogin()
  'click .logout': -> if confirm 'Are you sure you want to logout?' then Meteor.logout()
