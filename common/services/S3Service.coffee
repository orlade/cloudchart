@S3Service =
  id: 's3'
  name: 'S3'

  sync: ->
    s3 = UserAWS('S3', {region: 'ap-southeast-2'})
    State.s3Syncing++
    try S3Service.syncBuckets(s3)
    finally State.s3Syncing--

  syncBuckets: (s3) ->
    if Meteor.isClient then return log.warn "Cannot sync data from client"
    log.debug "Syncing S3 buckets..."

    {Buckets} = s3.listBucketsSync()
    buckets = for bucket in Buckets
      bucket = new S3Bucket(bucket)
      # TODO(orlade): Q.all.
      try
        bucket.website = s3.getBucketWebsiteSync {Bucket: bucket._id}
        hostName = bucket.website.RedirectAllRequestsTo?.HostName ? bucket._id
        bucket.website.url = "http://#{hostName}"
      catch e then log.debug e
      bucket
    Syncer.sync S3Buckets, buckets, true
    log.debug "Finished syncing S3 buckets"

  createBucket: (s3, name) ->
    {Location} = s3.createBucketSync {Bucket: name}
    Location

if Meteor.isClient
  Object.defineProperty S3Service, 'buckets', get: -> S3Buckets.find()
  Object.defineProperty S3Service, 'count', get: -> S3Buckets.find().count()

if Meteor.isServer
  Meteor.methods
    's3/createBucket': (bucket) ->
      s3 = UserAWS('S3', {region: 'ap-southeast-2'})
      State.s3Syncing++
      try
        location = S3Service.createBucket(s3, bucket.Name)
        log.debug "Created bucket #{bucket.Name} in #{location}"
        S3Service.syncBuckets(s3)
        location
      catch e then throw new Meteor.Error(e.statusCode, "#{e.code}: #{e.message}")
      finally State.s3Syncing--
