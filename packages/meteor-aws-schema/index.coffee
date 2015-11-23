schemafy = (name) -> name + 'Schema'

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
AWSSchemaNames = (schemafy(name) for name in AWSModelNames)

AWSModels = {}
AWSSchemas = {}

Meteor.startup =>
  # Index of model class by model name.
  for name in AWSModelNames
    AWSModels[name] = @[name]

  # Index of schemas by model name.
  for name in AWSModelNames
    AWSSchemas[name] = @[schemafy(name)]
