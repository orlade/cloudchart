Meteor.startup ->
  AccountsLocal.config({})

  Accounts.onCreateUser (options, user) ->
    console.log 'creating', user, options
    user.profile ?= options.profile ? {}

    # If created from a Google account, populate the emails and profile.
    if user.services?.google?
      user.emails = [{
        address: user.services.google.email
        verified: user.services.google.verified_email
      }]
      user.profile.avatar = user.services.google.picture

    # Derive username from email address.
    unless user.profile?.name then user.profile.name = user.emails[0].address.split('@')[0]

    user

  Meteor.methods
    # Updates a user's AWS credentials to the given values.
    setAwsCredentials: (accessKeyId, secretAccessKey) ->
      check accessKeyId, String
      check secretAccessKey, String

      log.debug "Updating #{Meteor.userId()} AWS credentials..."
      Meteor.users.update Meteor.userId(),
        $set:
          'services.aws.accessKeyId': accessKeyId
          'services.aws.secretAccessKey': secretAccessKey
          'profile.awsSet': true
