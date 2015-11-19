# Ensure no AWS accounts are authenticated on startup.
Meteor.startup -> @AwsSync.resetAuth()

# Facade for synchronization of AWS services.
@AwsSync =
  # The services to sync by default.
  services: [S3Service, EC2Service, ECSSyncService]

  # Unsets any existing AWS credentials. The `update` method requires both ID and key be provided
  # and not null.
  resetAuth: -> AWS.config.update {accessKeyId: 'null', secretAccessKey: 'null'}

  # Syncs data for the `services` specified by ID. If `services` is not provided, syncs all
  # supported services.
  sync: (services) ->
    State.syncing = true
    log.info "Syncing AWS service details..."

    # Determine which services to sync.
    if services? then services = @services.filter (s) -> _.contains services, s.id
    else services = @services

    try s.sync() for s in services
    # TODO(orlade): Handle concurrent syncs.
    finally State.syncing = false

Meteor.methods
  sync: ->
    Syncer.syncAll()
    true # Ensure no unserializable objects are returned.
