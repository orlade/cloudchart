Router.configure
  layoutTemplate: 'ApplicationLayout'
  yieldTemplates:
    navbar: to: 'header'
  data: -> _.extend State, @params

Router.route '/', {name: 'Dashboard'}

Router.route '/services/:id', {name: 'service'}
