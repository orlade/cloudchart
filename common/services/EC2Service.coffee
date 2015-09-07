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
    Syncer.sync EC2Instances, docs, true

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
