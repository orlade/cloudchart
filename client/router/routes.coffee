Router.configure
  layoutTemplate: 'ApplicationLayout'
  yieldTemplates:
    navbar: to: 'header'
    footer: to: 'footer'
  data: -> _.extend State, {App: App}, @params
  onAfterAction: ->
    page = _.last window.location.pathname.split('/')
    document.title = "#{Strings.toTitleCase Router.current().route.getName()} | #{App.name}"

AccountsTemplates.configure defaultLayout: 'ApplicationLayout'

Router.route '/', {name: 'home'}
Router.route '/dashboard', {name: 'dashboard'}
Router.route '/services/:id', {name: 'service'}
Router.route '/profile', {name: 'profile'}

Router.plugin 'ensureSignedIn',
  except: ['home', 'login'].concat _.pluck(AccountsTemplates.routes, 'name')

AccountsTemplates.configureRoute 'signIn',
  path: '/login'
  name: 'login'
  template: 'login'
