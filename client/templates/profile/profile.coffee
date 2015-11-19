Template.profile.helpers
  name: -> Meteor.user().profile.name ? "User"
  email: -> Meteor.user().emails?[0]?.address ? Meteor.user().services?.google?.email ? "None"
  awsSet: -> Meteor.user().profile.awsSet

Template.profile.events
  'click .aws.button': ->
    [modal, form] = [$('.aws.modal'), $('.aws.form')]
    modal.modal('show')
    get = (name) -> form.form('get value', name)
    form.submit (e) ->
      e.preventDefault()
      Meteor.call 'setAwsCredentials', get('accessKeyId'), get('secretAccessKey'), (err, res) ->
        if err then return log.error "Error setting AWS credentials", err
        closeForm()

  'click .cancel.button': -> closeForm()

closeForm = ->
  $('.aws.form').form('clear')
  $('.aws.modal').modal('hide')
