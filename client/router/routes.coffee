Router.configure
  layoutTemplate: 'ApplicationLayout'
  yieldTemplates:
    navbar: to: 'header'
    footer: to: 'footer'
  data: -> _.extend State, @params
  onBeforeAction: ->
    AccountsUi.signInRequired(@)
  action: -> if @ready() then @render()

Router.route '/', {name: 'Dashboard'}

Router.route '/services/:id', {name: 'service'}
