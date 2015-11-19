Template.s3.helpers
  buckets: -> S3Service.buckets

Template.S3Actions.helpers
  suggestions: ->
    unless Meteor.user() then return []
    buckets = [{
      name: Meteor.user().emails[0].address.split('@')[1]
      icon: 'world'
    }, {
      name: 'config'
      icon: 'setting'
    }]

    existing = _.pluck(S3Buckets.find({}, {fields: name: true}).fetch(), 'name')
    buckets.filter ({name}) -> name not in existing

Template.S3Actions.events
  'click .create.item': ->
    Meteor.call 's3/createBucket', name, (err, res) ->
      if err then return log.error "Error creating new S3 bucket #{name}", err

  'click .custom.item': ->
    [modal, form] = [$('.create.modal'), $('.create.form')]
    log.info form, modal
    modal.modal('show').modal({onHide: -> form.form('clear')})
    form.submit (e) ->
      e.preventDefault()
      form.find('.field, button').addClass('disabled')
      name = form.form('get value', 'name')
      Meteor.call 's3/createBucket', name, (err, res) ->
        form.find('.field, button').removeClass('disabled')
        if err then return log.error err
        modal.modal('hide')

Template.S3BucketTemplate.helpers
  manageUrl: -> "https://console.aws.amazon.com/s3/home?region=ap-southeast-2#&bucket=#{@_id}&prefix="

Template.s3.events
  'click .create.button .menu': ->

Template.s3.onRendered ->
  $('.create.card .content').dimmer({on: 'hover'})
