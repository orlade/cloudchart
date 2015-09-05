ecs = new AWS.ECS({region: 'ap-southeast-2'}) if Meteor.isServer

@ECSService =
  id: 'ecs'
  name: 'ECS'

  sync: ->
    if Meteor.isClient then return console.warn "Cannot sync data from client"

    # Task definitions.
    taskdefs = for id in ecs.listTaskDefinitionsSync().taskDefinitionArns
      taskdef = ecs.describeTaskDefinitionSync(taskDefinition: id).taskDefinition
      _.extend taskdef,
        _id: id
    Syncer.sync ECSTaskDefinitions, taskdefs, true

    # Services.
    serviceArns = ecs.listServicesSync().serviceArns
    if serviceArns.length
      services = for service in ecs.describeServicesSync(services: serviceArns)
        _.extend service,
          _id: service.serviceArn
      Syncer.sync ECSServices, services, true

    # Clusters.
    clusters = for cluster in ecs.describeClustersSync().clusters
      _.extend cluster,
        _id: cluster.clusterArn
        name: cluster.clusterName
    Syncer.sync ECSClusters, clusters, true


Object.defineProperty ECSService, 'taskdefs', get: -> ECSTaskDefinitions.find()
Object.defineProperty ECSService, 'services', get: -> ECSServices.find()
Object.defineProperty ECSService, 'clusters', get: -> ECSClusters.find()

#Object.defineProperty ECSService, 'services', get: -> _.flatten _.pluck(ECSClusters.find().fetch(),

Object.defineProperty ECSService, 'count', get: -> ECSServices.find().count()
