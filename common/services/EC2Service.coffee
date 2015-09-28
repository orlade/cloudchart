REGION_REGEX = /\w+\-\w+\-\d+/

@EC2Service =
  id: 'ec2'
  name: 'EC2'

  sync: ->
    if Meteor.isClient then return log.warn "Cannot sync data from client"

    reservations = new AWS.EC2({region: 'ap-southeast-2'}).describeInstancesSync().Reservations
    docs = for instance in _.flatten _.pluck(reservations, 'Instances')
      _.extend instance,
        _id: instance.InstanceId
        ip: instance.PublicIpAddress
        status: instance.State.Name
        spot: instance.SpotInstanceRequestId
        region: instance.Placement.AvailabilityZone.match(REGION_REGEX)[0]
    Syncer.sync EC2Instances, docs, true

    EC2Service.syncSpotPrices()

  # Looks up the latest spot price relevant for the current instances.
  syncSpotPrices: ->
    if Meteor.isClient then return log.warn "Cannot sync data from client"

    instances = EC2Instances.find().fetch()
    azTypes = {}
    for instance in instances when instance.spot
      types = azTypes[instance.Placement.AvailabilityZone]
      unless types? then types = azTypes[instance.Placement.AvailabilityZone] = {}
      typeInstances = types[instance.InstanceType]
      unless typeInstances? then typeInstances = types[instance.InstanceType] = []
      typeInstances.push instance

    for az, types of azTypes
      params =
        InstanceTypes: _.keys types
        MaxResults: _.size types
        ProductDescriptions: ['Linux/UNIX']

      handleResult = Meteor.bindEnvironment (err, res) ->
        if err then console.log "ERROR: Failed to get spot prices for", params, err
        else for price in res.SpotPriceHistory
          for instance in azTypes[price.AvailabilityZone][price.InstanceType]
            EC2Instances.update instance._id, $set: 'SpotPrice': price.SpotPrice

      new AWS.EC2({region: EC2Service.azToRegion(az)}).describeSpotPriceHistory params, handleResult
    azTypes

  azToRegion: (az) -> az.match(REGION_REGEX)[0]


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

Meteor.methods
  syncSpotPrices: -> if Meteor.isServer then EC2Service.syncSpotPrices()
