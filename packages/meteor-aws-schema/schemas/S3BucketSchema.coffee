S3BucketSchema =
  Name:
    type: String

  # Custom helper properties.
  name:
    type: String
  website:
    type: Object
    blackbox: true
    optional: true

# TODO: Refactor into schema.
ModelMapper.registerMapping 'S3Bucket',
  Name: (bucket, name) -> bucket._id = bucket.name = name
