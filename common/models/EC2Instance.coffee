class @EC2Instance extends Model
  _mapping:
    InstanceId: '_id'
    PublicIpAddress: 'ip'
    'State.Name': 'status'
    SpotInstanceRequestId: 'spot'
    'Placement.AvailabilityZone': (instance, az) -> instance.region = Region.azToRegion(az)

