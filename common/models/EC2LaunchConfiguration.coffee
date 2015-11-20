class @EC2LaunchConfiguration extends Model
  _type: "Launch Configuration"
  _methods: {}
    # create: 'ec2/createLaunchConfiguration'

  constructor: ->
    @_collection = EC2LaunchConfigurations
    super arguments...
