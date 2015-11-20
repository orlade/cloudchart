AutoScalingGroupSchema =
  AutoScalingGroupName:
    type: String
    label: "Name"
  LaunchConfigurationName:
    type: String
    label: "Launch Configuration"
    # autoform: options: ->
    #   configs = EC2LaunchConfigurations.find().fetch()
    #   ({label: c.LaunchConfigurationName, value: c._id} for c in configs)
