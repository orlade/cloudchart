SimpleSchema.extendOptions
  description: Match.Optional String

AWSModelNames = [
  'AutoScalingGroup'
  'EC2Instance'
  'EC2LaunchConfiguration'
  'ECSTask'
  'ECSTaskDefinition'
  'ECSTaskDefinitionFamily'
  'ECSCluster'
  'ECSService'
  'IAMRole'
  'S3Bucket'
]

schemafy = (name) -> name + 'Schema'

AWSSchemaNames = (schemafy(name) for name in AWSModelNames)
AWSSchemas = {}

Meteor.startup =>
  # Index of schemas by model name.
  for name in AWSModelNames
    AWSSchemas[name] = @[schemafy(name)]
