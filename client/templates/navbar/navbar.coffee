Template.navbar.helpers
  active: (routeName) -> "active" if Router.current().route.getName() == routeName

Template.navbar.events
  'click a.page.item': (e) ->
    console.log e.currentTarget.href
    Router.go e.currentTarget.href
    false
