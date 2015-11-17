# The AWS credentials to access your account, extracted from the environment.
AWS_AUTH =
  accessKeyId: process.env.AWS_ACCESS_KEY_ID
  secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY

# Ensure AWS credentials are available.
#
# TODO(orlade): Remove this after moving to user-based authentication.
for key, value of AWS_AUTH
  unless value? then throw new Error "Missing required credentials: #{key}"

Meteor.startup ->
  AWS.config.update AWS_AUTH
  # AwsSync.sync()

# Facade for synchronization of AWS services.
@AwsSync =
  # The services to sync by default.
  services: [S3Service, EC2Service, ECSSyncService]

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
  sync: -> Syncer.syncAll()
