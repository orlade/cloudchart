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

@ECSService =
  id: 'ecs'
  name: 'ECS'

  checkClient: -> if Meteor.isClient then throw new Error "Cannot sync data from client"

  sync: ->
    ECSService.syncClusters()
    ECSService.syncTaskDefs()

  syncTaskDefs: ->
    @checkClient()
    log.debug "Syncing task definitions..."
    ecs.listTaskDefinitionFamilies Meteor.bindEnvironment (err, data) ->
      if err? then return log.error "Failed to list task definition families:", err
      for familyName in data.families
        family = {_id: familyName, revisions: {}}

        try
          {taskDefinition} = ecs.describeTaskDefinitionSync {taskDefinition: familyName}
          mapMerge(taskDefinition, taskDefinition, MAPPINGS.TASK_DEFINITION)
          family.revisions[taskDefinition.revision] = taskDefinition
          family.status = taskDefinition.status
        catch err
          family.status = 'INACTIVE'
          log.error "Failed to describe task definition of #{familyName}:", err

        Syncer.sync ECSTaskDefinitionFamilies, [family]

  syncClusters: ->
    @checkClient()
    log.debug "Syncing clusters..."
    ecs.listClusters Meteor.bindEnvironment (err, {clusterArns}) ->
      if err? then return log.error "Failed to describe clusters:", err

      {clusters} = ecs.describeClustersSync {clusters: clusterArns}
      mapMerge(cluster, cluster, MAPPINGS.CLUSTER) for cluster in clusters

      # Sync the services of each cluster.
      for cluster in clusters
        {serviceArns} = ecs.listServicesSync {cluster: cluster._id}
        unless serviceArns?.length then continue

        {services} = ecs.describeServicesSync {services: serviceArns, cluster: cluster._id}
        mapMerge(service, service, MAPPINGS.SERVICE) for service in services

        # Sync the tasks of each service.
        for service in services
          {taskArns} = ecs.listTasksSync {serviceName: service.name, cluster: cluster._id}
          unless taskArns?.length then continue

          {tasks} = ecs.describeTasksSync {tasks: taskArns, cluster: cluster._id}
          mapMerge(task, task, MAPPINGS.TASK) for task in tasks

          service.tasks = tasks
        cluster.services = services
      Syncer.sync ECSClusters, clusters, true


  # Scales the `service` to run `count` instances on `cluster`.
  scale: (service, count, cluster = 'default') ->
    log.info "Scaling #{service} to #{count} instances on #{cluster}..."
    if Meteor.isClient then return Meteor.call 'ecs/scale', service, count, cluster

    ecs.updateServiceSync {service: service, cluster: cluster, desiredCount: count}
#    Syncer.sync 'ecs'

Object.defineProperty ECSService, 'taskdefs', get: -> ECSTaskDefinitionFamilies.find()
Object.defineProperty ECSService, 'clusters', get: -> ECSClusters.find()

Object.defineProperty ECSService, 'count', get: -> ECSClusters.find().count()

if Meteor.isServer
  Meteor.methods
    'ecs/scale': (args...) -> ECSService.scale args...
