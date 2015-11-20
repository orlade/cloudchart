COLLECTIONS = [
  'EC2Instances'
  'EC2LaunchConfigurations'
  'ECSTaskDefinitionFamilies'
  'ECSClusters'
  'S3Buckets'
]

for name in COLLECTIONS
  # Create each collection by name on client and server
  @[name] = new Mongo.Collection name

  # Publish on the server, subscribe on the client.
  if Meteor.isServer then Meteor.publish name, => @[name].find({userId: @userId})
  else Meteor.subscribe name
