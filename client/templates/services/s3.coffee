Template.s3.helpers
  buckets: -> S3Service.buckets
  bucketItems: ->
    buckets = [{
      name: "Suggestions"
      items: [
        {name: Meteor.user()?.emails[0].address.split('@')[1], icon: 'world'}
        {name: 'config', icon: 'setting'}
      ]
    }]
    existing = _.pluck(S3Buckets.find({}, {fields: name: true}).fetch(), 'name')
    for group in buckets
      # Remove any items that have the same name as an existing bucket.
      for i in [group.items.length - 1..0]
        if group.items[i].name in existing then group.items[i..i] = []
    buckets

  bucketSchema: -> new SimpleSchema {Name: {type: String}}

Template.s3.events
  'click .create.bucket .create.item': -> new S3Bucket({Name: @name}).create()

Template.CreateMenu.onCreated ->
  @customHooks['bucket'] = (formValues, callback) -> new S3Bucket(formValues).create(callback)

Template.S3BucketTemplate.helpers
  manageUrl: -> "https://console.aws.amazon.com/s3/home?region=ap-southeast-2#&bucket=#{@_id}&prefix="
