# Details about instances running on EC2, including reserved and spot instances.
@EC2Instances = new Mongo.Collection 'ec2-instances'

# Details about ECS resources.
@ECSTaskDefinitions = new Mongo.Collection 'ecs-taskdefs'
@ECSServices = new Mongo.Collection 'ecs-services'
@ECSClusters = new Mongo.Collection 'ecs-clusters'

# Details about S3 buckets.
@S3Buckets = new Mongo.Collection 's3-buckets'
