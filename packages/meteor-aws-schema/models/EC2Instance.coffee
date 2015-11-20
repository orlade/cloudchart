TAG_KEY_MAP =
  name: 'name'
  Name: 'name'
  'aws:autoscaling:groupName': 'autoscaleGroup'

class EC2Instance extends AWSModel
  _mapping:
    InstanceId: '_id'
    PublicIpAddress: 'ip'
    'State.Name': 'status'
    SpotInstanceRequestId: 'spot'
    'Placement.AvailabilityZone': (instance, az) -> instance.region = Region.azToRegion(az)
    Tags: (instance, tags) ->
      for {Key, Value} in tags when Key of TAG_KEY_MAP
        instance[TAG_KEY_MAP[Key]] = Value
