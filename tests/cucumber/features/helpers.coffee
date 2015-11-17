module.exports = ->

  ROOT_URL = 'http://localhost:3000'
  login = (done) -> Meteor.loginWithPhony Package['csauer:accounts-phony'].Phony.user, done

  @Given 'I am logged in', ->
    @browser.url(ROOT_URL)
    @browser.timeoutsAsyncScript(5000)
    @browser.executeAsync(login)

  @Given 'I am on the Dashboard', -> @browser.url("#{ROOT_URL}/dashboard")
