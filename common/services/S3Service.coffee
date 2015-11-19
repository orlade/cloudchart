@S3Service =
  id: 's3'
  name: 'S3'

  sync: ->
    s3 = UserAWS('S3', {region: 'ap-southeast-2'})
    S3Service.syncBuckets(s3)

  syncBuckets: (s3) ->
    if Meteor.isClient then return log.warn "Cannot sync data from client"
    log.debug "Syncing S3 buckets..."

    s3.listBuckets Meteor.bindEnvironment (err, {Buckets}) ->
      buckets = for bucket in Buckets
        bucket = new S3Bucket(bucket)
        # TODO(orlade): Q.all.
        try
          bucket.website = s3.getBucketWebsiteSync {Bucket: bucket._id}
          hostName = bucket.website.RedirectAllRequestsTo?.HostName ? bucket._id
          bucket.website.url = "http://#{hostName}"
        catch e
          log.debug e
          bucket.website = false
        bucket
      Syncer.sync S3Buckets, buckets, true
      log.debug "Finished syncing S3 buckets"

if Meteor.isClient
  Object.defineProperty S3Service, 'buckets', get: -> S3Buckets.find()
  Object.defineProperty S3Service, 'count', get: -> S3Buckets.find().count()

if Meteor.isServer
  Meteor.methods
    's3/createBucket': (name) ->
      throw new Error "s3/createBucket not implemented"
