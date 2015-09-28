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

  # Looks up the latest spot price relevant for the current instances.
  getSpotPrices: ->
    if Meteor.isClient then return log.warn "Cannot request spot prices from the client"
    params =
#      AvailabilityZone: instance.Placement.AvailabilityZone
      InstanceTypes: []
#      MaxResults: 1
      ProductDescriptions: ['Linux/UNIX']
      Filters: [{Name: 'timestamp', Values: [new Date().toISOString()]}]

    instances = EC2Instances.find().fetch()
    params.Instancetypes = _.uniq(instance.InstanceType for instance in instances)

    data = new AWS.EC2({region: instance.region}).describeSpotPriceHistorySync(params).SpotPriceHistory

    output = {}
    for instance in instances
      output[instance._id] = data.filter((price) -> instance.InstanceType == price.InstanceType and
        instance.Placement.AvailabilityZone == price.AvailabilityZone)[0].SpotPrice
    console.log output
    output


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
  getSpotPrices: -> if Meteor.isServer then EC2Service.getSpotPrices()
