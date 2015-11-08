COLLECTIONS = [
  'ec2-instances'
  'ecs-task-definition-families'
  'ecs-services'
  'ecs-clusters'
  's3-buckets'
]

# Publish on the server.
if Meteor.isServer
  Meteor.publish 'ec2-instances', -> EC2Instances.find()
  Meteor.publish 'ecs-task-definition-families', -> ECSTaskDefinitionFamilies.find()
  Meteor.publish 'ecs-services', -> ECSServices.find()
  Meteor.publish 'ecs-clusters', -> ECSClusters.find()
  Meteor.publish 's3-buckets', -> S3Buckets.find()
# Subscribe on the client.
else Meteor.subscribe(c) for c in COLLECTIONS

# Details about instances running on EC2, including reserved and spot instances.
@EC2Instances = new Mongo.Collection 'ec2-instances'

# Details about ECS resources.
@ECSTaskDefinitionFamilies = new Mongo.Collection 'ecs-task-definition-families'
@ECSServices = new Mongo.Collection 'ecs-services'
@ECSClusters = new Mongo.Collection 'ecs-clusters'

# Details about S3 buckets.
@S3Buckets = new Mongo.Collection 's3-buckets'
