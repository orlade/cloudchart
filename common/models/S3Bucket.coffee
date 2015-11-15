class @S3Bucket extends Model
  _mapping:
    Name: (bucket, name) -> bucket._id = bucket.Name = name
