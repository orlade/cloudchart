Router.configure
  layoutTemplate: 'ApplicationLayout'
  yieldTemplates:
    navbar: to: 'header'
    footer: to: 'footer'
  data: -> _.extend State, {App: App}, @params
  # onBeforeAction: ->
    # unless Meteor.userId() then Router.go '/login'
    # @next()
  # action: -> if @ready() then @render()

AccountsTemplates.configure defaultLayout: 'ApplicationLayout'

Router.route '/', {name: 'home'}
Router.route '/dashboard', {name: 'dashboard'}
Router.route '/login', {name: 'login'}
Router.route '/services/:id', {name: 'service'}

Router.plugin 'ensureSignedIn',
  except: ['home', 'login'].concat _.pluck(AccountsTemplates.routes, 'name')

AccountsTemplates.configureRoute('changePwd')
AccountsTemplates.configureRoute('enrollAccount')
AccountsTemplates.configureRoute('forgotPwd')
AccountsTemplates.configureRoute('resetPwd')
AccountsTemplates.configureRoute('signIn')
AccountsTemplates.configureRoute('signUp')
AccountsTemplates.configureRoute('verifyEmail')
