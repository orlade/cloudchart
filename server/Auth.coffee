Meteor.startup ->
  AccountsLocal.config()

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
