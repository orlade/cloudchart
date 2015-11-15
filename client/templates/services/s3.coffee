Template.s3.helpers
  buckets: -> S3Service.buckets

Template.S3BucketTemplate.helpers
  manageUrl: -> "https://console.aws.amazon.com/s3/home?region=ap-southeast-2#&bucket=#{@_id}&prefix="
