# Details about instances running on EC2, including reserved and spot instances.
@EC2Instances = new Mongo.Collection 'ec2-instances'

# Details about ECS resources.
@ECSClusters = new Mongo.Collection 'ecs-clusters'
@ECSTaskDefinitions = new Mongo.Collection 'ecs-taskdefs'

# Details about S3 buckets.
@S3Buckets = new Mongo.Collection 's3-buckets'
