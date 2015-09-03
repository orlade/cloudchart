Router.configure
  layoutTemplate: 'ApplicationLayout'
  yieldTemplates:
    navbar: to: 'header'
#    footer: to: 'footer'

Router.route '/', {name: 'Dashboard'}

Router.route '/services/:id',
  name: 'service'
  data: -> @params
