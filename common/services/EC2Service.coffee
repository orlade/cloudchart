@EC2Service =
  id: 'ec2'
  name: 'EC2'

  sync: ->
    if Meteor.isClient then return console.warn "Cannot sync data from client"

    syncInstances = Meteor.bindEnvironment((docs) -> Syncer.sync EC2Instances, docs, true)

#    console.log new AWS.EC2({region: 'ap-southeast-2'}).describeInstancesSync()
    reservations = new AWS.EC2({region: 'ap-southeast-2'}).describeInstancesSync().Reservations
    docs = for instance in _.flatten _.pluck(reservations, 'Instances')
      _.extend instance,
        _id: instance.InstanceId
        ip: instance.PublicIpAddress
        status: instance.State.Name
        spot: instance.SpotInstanceRequestId
    Syncer.sync EC2Instances, docs, true

    # Spot instances.
#    spots = new AWS.EC2({region: 'ap-southeast-2'}).describeSpotInstanceRequestsSync()
#    console.log spots

#    syncInstances docs


Object.defineProperty EC2Service, 'instances', get: -> EC2Instances.find()
