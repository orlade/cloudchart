COLLECTIONS = [
  'ec2-instances'
  'ecs-taskdefs'
  'ecs-services'
  'ecs-clusters'
  's3-buckets'
]

# Publish on the server.
if Meteor.isServer
  Meteor.publish 'ec2-instances', -> EC2Instances.find()
  Meteor.publish 'ecs-taskdefs', -> ECSTaskDefinitions.find()
  Meteor.publish 'ecs-services', -> ECSServices.find()
  Meteor.publish 'ecs-clusters', -> ECSClusters.find()
  Meteor.publish 's3-buckets', -> S3Buckets.find()
# Subscribe on the client.
else Meteor.subscribe(c) for c in COLLECTIONS

# Details about instances running on EC2, including reserved and spot instances.
@EC2Instances = new Mongo.Collection 'ec2-instances'

# Details about ECS resources.
@ECSTaskDefinitions = new Mongo.Collection 'ecs-taskdefs'
@ECSServices = new Mongo.Collection 'ecs-services'
@ECSClusters = new Mongo.Collection 'ecs-clusters'

# Details about S3 buckets.
@S3Buckets = new Mongo.Collection 's3-buckets'
