s3 = new AWS.S3()

@S3Service =
  id: 's3'
  name: 'S3'

  sync: ->
    S3Service.syncBuckets()

  syncBuckets: ->
    if Meteor.isClient then return log.warn "Cannot sync data from client"
    log.debug "Syncing S3 buckets..."

    s3.listBuckets Meteor.bindEnvironment (err, {Buckets}) ->
      buckets = (new S3Bucket(bucket) for bucket in Buckets)
      Syncer.sync S3Buckets, buckets, true
      log.debug "Finished syncing S3 buckets"

Object.defineProperty S3Service, 'buckets', get: -> S3Buckets.find()
Object.defineProperty S3Service, 'count', get: -> S3Buckets.find().count()
