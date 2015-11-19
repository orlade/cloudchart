@ECSSyncService =
  id: 'ecs'
  name: 'ECS'

  checkClient: -> if Meteor.isClient then throw new Error "Cannot sync data from client"

  sync: ->
    ecs = UserAWS('ECS', {region: 'ap-southeast-2'}) if Meteor.isServer

    State.ecsSyncing += 2
    try ECSSyncService.syncClusters(ecs)
    finally State.ecsSyncing--

    try ECSSyncService.syncTaskDefs(ecs)
    finally State.ecsSyncing--

  syncTaskDefs: (ecs) ->
    @checkClient()
    log.debug "Syncing task definitions..."
    {families: familyNames} = ecs.listTaskDefinitionFamiliesSync()
    families = for familyName in familyNames
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

  syncClusters: (ecs) ->
    @checkClient()
    log.debug "Syncing clusters..."
    {clusterArns} = ecs.listClustersSync()
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

if Meteor.isClient
  Object.defineProperty ECSSyncService, 'taskdefs', get: -> ECSTaskDefinitionFamilies.find()
  Object.defineProperty ECSSyncService, 'clusters', get: -> ECSClusters.find()

  Object.defineProperty ECSSyncService, 'count', get: -> ECSClusters.find().count()

if Meteor.isServer
  Meteor.methods
    'ecs/scale': (args...) ->
      ECSSyncService.scale args...
      true
