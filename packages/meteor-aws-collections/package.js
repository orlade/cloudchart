Package.describe({
  summary: "Meteor collections for the AWS SDK",
  version: '0.0.1',
  name: 'orlade:aws-collections',
  git: 'https://github.com/orlade/meteor-aws-collections.git'
});

Package.on_use(function (api) {
  api.versionsFrom('METEOR@1.0');
  api.use([
    'coffeescript',

    'aramk:utility@0.11.0',
    'aldeed:collection2',
    'matb33:collection-hooks',
    'orlade:aws-schema'
  ]);

  api.export([
    'AWSCollections',
    'AWSCollectionsConfig'
  ]);

  api.add_files([
    'relationships.coffee',
    'collections.coffee',
    'crud.coffee'
  ]);
});
