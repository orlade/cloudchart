# Get an AWS service constructor using the given authentication credentials. If no credentials are
# given, try to use the "current" user (assuming a `Meteor.call` was made).
@UserAWS = (serviceName, args...) ->
  auth = Meteor.users.findOne(Meteor.userId()).services.aws
  check auth, Object
  check auth.accessKeyId, String
  check auth.secretAccessKey, String

  AWS.config.update auth
  ServiceClass = AWS[serviceName]
  log.debug "Creating #{serviceName} service for user #{Meteor.userId()} (#{auth.accessKeyId})"
  service = new ServiceClass args...
  AwsSync.resetAuth()
  service
