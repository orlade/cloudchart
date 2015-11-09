ec2 = new AWS.EC2({region: 'ap-southeast-2'})

@EC2Service =
  id: 'ec2'
  name: 'EC2'

  sync: ->
    EC2Service.syncInstances()
#    EC2Service.syncSpotPrices()

  syncInstances: ->
    if Meteor.isClient then return log.warn "Cannot sync data from client"
    log.debug "Syncing EC2 instances..."

    ec2.describeInstances Meteor.bindEnvironment (err, {Reservations}) ->
      docs = (new EC2Instance(inst) for inst in _.flatten _.pluck(Reservations, 'Instances'))
      Syncer.sync EC2Instances, docs, true
      log.debug "Finished syncing EC2 instances"

  # Looks up the latest spot price relevant for the current instances.
  syncSpotPrices: ->
    if Meteor.isClient then return log.warn "Cannot sync data from client"
    log.debug "Syncing EC2 spot prices..."

    instances = EC2Instances.find().fetch()
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

      handleResult = Meteor.bindEnvironment (err, res) ->
        if err then console.log "ERROR: Failed to get spot prices for", params, err
        else for price in res.SpotPriceHistory
          for instance in azTypes[price.AvailabilityZone][price.InstanceType]
            EC2Instances.update instance._id, $set: 'SpotPrice': price.SpotPrice

      new AWS.EC2({region: Region.azToRegion(az)}).describeSpotPriceHistory params, handleResult
    azTypes



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
