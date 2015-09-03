ecs = new AWS.ECS({region: 'ap-southeast-2'}) if Meteor.isServer

@ECSService =
  id: 'ecs'
  name: 'ECS'

  sync: ->
    if Meteor.isClient then return console.warn "Cannot sync data from client"

    # Clusters.
    clusters = for cluster in ecs.describeClustersSync().clusters
      _.extend cluster,
        _id: cluster.clusterArn
        name: cluster.clusterName
    Syncer.sync ECSClusters, clusters, true

    # Task definitions.
    taskdefs = for id in ecs.listTaskDefinitionsSync().taskDefinitionArns
      taskdef = ecs.describeTaskDefinitionSync(taskDefinition: id).taskDefinition
      _.extend taskdef,
        _id: id
    Syncer.sync ECSTaskDefinitions, taskdefs, true

Object.defineProperty ECSService, 'clusters', get: -> ECSClusters.find()
Object.defineProperty ECSService, 'taskdefs', get: -> ECSTaskDefinitions.find()
