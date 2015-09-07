Meteor.startup ->
  AWS.config.update
    accessKeyId: process.env.AWS_ACCESS_KEY_ID
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY
  AwsSync.sync()

@AwsSync =
  services: [S3Service, EC2Service, ECSService]

  # Syncs data for the `services` specified by ID. If `services` is not provided, syncs all
  # services.
  sync: (services) ->
    State.syncing = true
    log.info "Syncing AWS service details..."

    # Determine which services to sync.
    if services? then services = @services.filter (s) -> _.contains services, s.id
    else services = @services

    try s.sync() for s in services
    finally State.syncing = false

Meteor.methods
  sync: -> Syncer.syncAll()
