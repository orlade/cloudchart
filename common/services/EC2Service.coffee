@EC2Service =
  id: 'ec2'
  name: 'EC2'

  sync: ->
    ec2 = UserAWS('EC2', {region: 'ap-southeast-2'})

    State.ec2Syncing++
    try EC2Service.syncInstances(ec2)
#    EC2Service.syncSpotPrices(ec2)
    finally State.ec2Syncing--

  syncInstances: (ec2) ->
    if Meteor.isClient then return log.warn "Cannot sync data from client"
    log.debug "Syncing EC2 instances..."

    {Reservations} = ec2.describeInstancesSync()
    Instances = _.flatten _.pluck(Reservations, 'Instances')
    docs = ModelFactory.create 'EC2Instance', Instances
    Syncer.sync EC2Instances, docs, true
    log.debug "Finished syncing EC2 instances"

  # Looks up the latest spot price relevant for the current instances.
  syncSpotPrices: (ec2) ->
    if Meteor.isClient then return log.warn "Cannot sync data from client"
    log.debug "Syncing EC2 spot prices..."

    instances = EC2Instances.find({userId: Meteor.userId()}).fetch()
    azTypes = {}
    for instance in instances when instance.spot
      types = azTypes[instance.Placement.AvailabilityZone]
      unless types? then types = azTypes[instance.Placement.AvailabilityZone] = {}
      typeInstances = types[instance.InstanceType]
      unless typeInstances? then typeInstances = types[instance.InstanceType] = []
      typeInstances.push instance

    _.each azTypes, Meteor.bindEnvironment (types, az) ->
      params =
        InstanceTypes: _.keys types
        MaxResults: _.size types
        ProductDescriptions: ['Linux/UNIX']
        Filters: [{
          Name: 'availability-zone'
          Values: [az]
        }]

      azec2 = UserAWS('EC2', {region: Region.azToRegion(az)})
      {SpotPriceHistory} = azec2.describeSpotPriceHistorySync(params)
      for price in SpotPriceHistory
        for instance in azTypes[price.AvailabilityZone][price.InstanceType]
          EC2Instances.update instance._id, $set: 'SpotPrice': price.SpotPrice

  createLaunchConfiguration: (as, lc) ->
    EC2LaunchConfigurations.simpleSchema().clean(lc)
    delete lc._id
    log.debug "Creating launch configuration", lc
    data = as.createLaunchConfigurationSync lc
    log.debug "Created", data
    data


if Meteor.isClient
  Object.defineProperties EC2Service,
    # The number of EC2 instances.
    count: get: -> EC2Instances.find().count()
    # The existing EC2 instances.
    instances: get: -> EC2Instances.find()

    # Elastic Load Balancer (ELB) instances.
    elbs: get: ->
    # EC2 instance launch configurations.
    launchConfigs: get: ->
    # Auto-Scaling Group (ASG) instances.
    asgs: get: ->

if Meteor.isServer
  Meteor.methods
    syncSpotPrices: ->
      EC2Service.syncSpotPrices()
      true

    'ec2/createLaunchConfiguration': (lc) ->
      as = new UserAWS('AutoScaling', {region: 'ap-southeast-2'})
      EC2Service.createLaunchConfiguration(as, lc)
      true
