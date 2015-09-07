Meteor.startup ->
  AWS.config.update
    accessKeyId: process.env.AWS_ACCESS_KEY_ID
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY
  AwsSync.sync()

@AwsSync =
  services: [S3Service, EC2Service, ECSService]
  sync: ->
    State.syncing = true
    log.info "Syncing AWS service details..."
    try s.sync() for s in @services
    finally State.syncing = false

Meteor.methods
  sync: -> Syncer.syncAll()
