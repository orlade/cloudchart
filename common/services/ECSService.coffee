ecs = new AWS.ECS({region: 'ap-southeast-2'}) if Meteor.isServer

@ECSService =
  id: 'ecs'
  name: 'ECS'

  sync: ->
    if Meteor.isClient then return log.warn "Cannot sync data from client"

    # Task definitions.
    taskdefs = for id in ecs.listTaskDefinitionsSync().taskDefinitionArns
      taskdef = ecs.describeTaskDefinitionSync(taskDefinition: id).taskDefinition
      _.extend taskdef,
        _id: id
    Syncer.sync ECSTaskDefinitions, taskdefs, true

    # Services.
    serviceArns = ecs.listServicesSync().serviceArns
    if serviceArns.length
      services = for service in ecs.describeServicesSync(services: serviceArns).services
        _.extend service,
          _id: service.serviceArn
          name: service.serviceName

        # Attach details of the tasks to the service if there are any.
        taskArns = ecs.listTasksSync(family: service.name).taskArns
        if taskArns.length
          service.tasks = for task in ecs.describeTasksSync(tasks: taskArns).tasks
            _.extend task,
              _id: task.taskArn
              status: task.lastStatus
              errors: (c.reason for c in task.containers when c.reason?)
        service

      Syncer.sync ECSServices, services, true

    # Clusters.
    clusters = for cluster in ecs.describeClustersSync().clusters
      _.extend cluster,
        _id: cluster.clusterArn
        name: cluster.clusterName
    Syncer.sync ECSClusters, clusters, true

  # Scales the `service` to run `count` instances on `cluster`.
  scale: (service, count, cluster = 'default') ->
    log.info "Scaling #{service} to #{count} instances on #{cluster}..."
    if Meteor.isClient then return Meteor.call 'ecs/scale', service, count, cluster

    ecs.updateServiceSync {service: service, cluster: cluster, desiredCount: count}
    Syncer.sync 'ecs'

Object.defineProperty ECSService, 'taskdefs', get: -> ECSTaskDefinitions.find()
Object.defineProperty ECSService, 'services', get: -> ECSServices.find()
Object.defineProperty ECSService, 'clusters', get: -> ECSClusters.find()

Object.defineProperty ECSService, 'count', get: -> ECSServices.find().count()

if Meteor.isServer
  Meteor.methods
    'ecs/scale': (args...) -> ECSService.scale args...
