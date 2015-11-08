@S3Service =
  id: 's3'
  name: 'S3'

  sync: ->
    if Meteor.isClient then return log.warn "Cannot sync data from client"
    log.debug "Syncing S3 buckets..."

    buckets = for bucket in new AWS.S3().listBucketsSync().Buckets
      _.extend bucket, _id: bucket.Name
    Syncer.sync S3Buckets, buckets, true

Object.defineProperty S3Service, 'buckets', get: -> S3Buckets.find()
Object.defineProperty S3Service, 'count', get: -> S3Buckets.find().count()
