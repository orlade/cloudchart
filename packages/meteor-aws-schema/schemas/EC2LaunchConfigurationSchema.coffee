EC2LaunchConfigurationSchema =
    LaunchConfigurationName:
      type: String,
      label: "Name"
      max: 50
    BlockDeviceMappings:
      type: [Object]
      blackbox: true
    EbsOptimized:
      type: Boolean
    IamInstanceProfile:
      type: String
    ImageId:
      type: String
    InstanceMonitoring:
      type: Object
      blackbox: true
    InstanceType:
      type: String
    SecurityGroups:
      type: [Object]
      blackbox: true
    UserData:
      type: String

for key, value of EC2LaunchConfigurationSchema
  value.optional = true

# TODO: Refactor into schema.
ModelMapper.registerMapping 'EC2LaunchConfiguration',
  LaunchConfigurationName: (lc, name) -> lc._id = lc.name = name
