STATUS_COLOR =
  'pending': 'blue'
  'running': 'green'
  'shutting-down': 'yellow'
  'terminated': 'black'
  'stopping': 'yellow'
  'stopped': 'grey'
  'active': 'green'
  'inactive': 'red'


DEFAULT_COLOR = 'blue'

@Status =
  getColor: (status) -> STATUS_COLOR[status?.toLowerCase()] ? DEFAULT_COLOR

Template.registerHelper 'color', (status) -> Status.getColor(@status ? status)
Template.registerHelper 'upperCase', (string) -> string?.toUpperCase()