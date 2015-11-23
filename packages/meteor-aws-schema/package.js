Package.describe({
  summary: "Schema and data modelling classes for the AWS SDK",
  version: '0.0.1',
  name: 'orlade:aws-schema',
  git: 'https://github.com/orlade/meteor-aws-schema.git'
});

var MODELS = [
  'AutoScalingGroup',
  'EC2Instance',
  'EC2LaunchConfiguration',
  'ECSTask',
  'ECSTaskDefinition',
  'ECSTaskDefinitionFamily',
  'ECSCluster',
  'ECSService',
  'IAMRole',
  'S3Bucket'
];
var SCHEMAS = MODELS.map(function(m) {return m + 'Schema'});

Package.on_use(function (api) {
  api.versionsFrom('METEOR@1.0');
  api.use([
    'coffeescript',
    'check',

    'aramk:utility@0.11.0',
    'aldeed:simple-schema@1.3.3'
  ]);

  api.export([
    'ModelMapper',

    'AWSModelNames',
    'AWSSchemaNames',
    'AWSModels',
    'AWSSchemas',

    'AWSModel'
  ].concat(MODELS, SCHEMAS));

  api.add_files([
    'util/ModelMapper.coffee',

    'models/Model.coffee'
  ].concat(
    SCHEMAS.map(function(schema) {return 'schemas/' + schema + '.coffee'}),
    MODELS.map(function(model) {return 'models/' + model + '.coffee'})
  ).concat('index.coffee'));
});
