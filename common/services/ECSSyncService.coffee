ecs = new AWS.ECS({region: 'ap-southeast-2'}) if Meteor.isServer

# Mappings of AWS property names to more convenient ones.
MAPPINGS =
  CLUSTER:
    clusterArn: '_id'
    clusterName: 'name'

  SERVICE:
    serviceArn: '_id'
    serviceName: 'name'
    taskDefinition: (service, tdArn) -> service.taskdefName = _.last tdArn.split('/')

  TASK:
    taskArn: (task, arn) ->
      task._id = arn
      task.taskId = _.last arn.split('/')
    lastStatus: 'status'
    containers: (task, containers) -> task.errors = (c.reason for c in containers when c.reason?)
    # Extract the task definition family and revision as the "name" of the task.
    taskDefinitionArn: (task, tdArn) -> task.name = _.last tdArn.split('/')

  TASK_DEFINITION:
    taskDefinitionArn : '_id'

mapMerge = (destination, source, mapping) ->
  for sourceKey, destKey of mapping
    if sourceKey of source
      if typeof destKey == 'string' then destination[destKey] = source[sourceKey]
      # If the destination key is a function, apply it and let it write the correct property.
      else if typeof destKey == 'function' then destKey(destination, source[sourceKey])
  destination

@ECSSyncService =
  id: 'ecs'
  name: 'ECS'

  checkClient: -> if Meteor.isClient then throw new Error "Cannot sync data from client"

  sync: ->
    ECSSyncService.syncClusters()
    ECSSyncService.syncTaskDefs()

  syncTaskDefs: ->
    @checkClient()
    log.debug "Syncing task definitions..."
    ecs.listTaskDefinitionFamilies Meteor.bindEnvironment (err, data) ->
      if err? then return log.error "Failed to list task definition families:", err
      families = for familyName in data.families
        family = {_id: familyName, revisions: {}}

        try
          {taskDefinition} = ecs.describeTaskDefinitionSync {taskDefinition: familyName}
          taskDefinition = new ECSTaskDefinition(taskDefinition)
          family.revisions[taskDefinition.revision] = taskDefinition
          family.status = taskDefinition.status
        catch err
          family.status = 'INACTIVE'
          log.warn "Failed to describe task definition of #{familyName}:", err
        family
      Syncer.sync ECSTaskDefinitionFamilies, families
      log.debug "Finished syncing ECS task definitions"

  syncClusters: ->
    @checkClient()
    log.debug "Syncing clusters..."
    ecs.listClusters Meteor.bindEnvironment (err, {clusterArns}) ->
      if err? then return log.error "Failed to describe clusters:", err

      {clusters} = ecs.describeClustersSync {clusters: clusterArns}
      clusters = (new ECSCluster(cluster) for cluster in clusters)

      # Sync the services of each cluster.
      for cluster in clusters
        {serviceArns} = ecs.listServicesSync {cluster: cluster._id}
        unless serviceArns?.length then continue

        {services} = ecs.describeServicesSync {services: serviceArns, cluster: cluster._id}
        services = (new ECSService(service) for service in services)

        # Sync the tasks of each service.
        for service in services
          {taskArns} = ecs.listTasksSync {serviceName: service.name, cluster: cluster._id}
          unless taskArns?.length then continue

          {tasks} = ecs.describeTasksSync {tasks: taskArns, cluster: cluster._id}
          tasks = (new ECSTask(task) for task in tasks)

          service.tasks = tasks
        cluster.services = services
      Syncer.sync ECSClusters, clusters, true
      log.debug "Finished syncing ECS clusters"


# Scales the `service` to run `count` instances on `cluster`.
  scale: (service, count, cluster = 'default') ->
    log.info "Scaling #{service} to #{count} instances on #{cluster}..."
    if Meteor.isClient then return Meteor.call 'ecs/scale', service, count, cluster

    ecs.updateServiceSync {service: service, cluster: cluster, desiredCount: count}
#    Syncer.sync 'ecs'

Object.defineProperty ECSSyncService, 'taskdefs', get: -> ECSTaskDefinitionFamilies.find()
Object.defineProperty ECSSyncService, 'clusters', get: -> ECSClusters.find()

Object.defineProperty ECSSyncService, 'count', get: -> ECSClusters.find().count()

if Meteor.isServer
  Meteor.methods
    'ecs/scale': (args...) -> ECSSyncService.scale args...
