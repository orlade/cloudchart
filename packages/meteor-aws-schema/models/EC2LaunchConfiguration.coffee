class EC2LaunchConfiguration extends AWSModel
  @schema: new SimpleSchema(EC2LaunchConfigurationSchema)

  _type: "Launch Configuration"
  _methods:
    create: 'ec2/createLaunchConfiguration'

  _mapping:
    LaunchConfigurationName: (lc, name) -> lc._id = lc.name = name

  constructor: ->
    @_collection = EC2LaunchConfigurations
    super arguments...
