Meteor.startup ->
  AccountsUi.config
    afterLogin: -> Router.go '/'
    loginRoute: 'login'
    loginTemplate: 'loginForm'
