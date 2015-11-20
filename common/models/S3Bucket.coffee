class @S3Bucket extends Model
  _type: "Bucket"
  _methods:
    create: 's3/createBucket'

  _id: undefined
  Name: undefined

  _mapping:
    Name: (bucket, name) -> bucket._id = bucket.Name = name

  constructor: ->
    super arguments...
    @_collection = S3Buckets
