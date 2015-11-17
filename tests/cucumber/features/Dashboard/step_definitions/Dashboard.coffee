module.exports = ->
  @Then 'I can see service cards', -> @browser.waitForExist(".service.card").should.equal(true)
