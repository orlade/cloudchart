@S3Service =
  id: 's3'
  name: 'S3'

  sync: ->
    if Meteor.isClient then return console.warn "Cannot sync data from client"

    buckets = for bucket in new AWS.S3().listBucketsSync().Buckets
      _.extend bucket, _id: bucket.Name
    Syncer.sync S3Buckets, buckets, true

Object.defineProperty S3Service, 'buckets', get: -> S3Buckets.find()
