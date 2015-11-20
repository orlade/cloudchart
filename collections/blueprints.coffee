@Blueprints =
  EC2LaunchConfigurations:
    ecsMicro: (args) ->
      check args.ecsConfigPath, String
      # check args.securityGroupId String

      new EC2LaunchConfiguration
        LaunchConfigurationName: "ECS t2.micro"
        BlockDeviceMappings: [{DeviceName: 'xvda', Ebs: VolumeSize: 30}]
        EbsOptimized: false # Maybe true?
        IamInstanceProfile: 'ecsServiceRole' # TODO: Lookup
        ImageId: 'B00U6QTYI2'
        InstanceMonitoring: Enabled: false
        InstanceType: 't2.micro'
        # SecurityGroups: [args.securityGroupId] # TODO: Search/create
        UserData: "#!/bin/bash
yum install -y aws-cli
aws s3 cp s3://#{args.ecsConfigPath} /etc/ecs/ecs.config" # TODO: Search/create

#   AutoScalingGroups:
#     ecsMicro: (args) ->
#       check args.launchConfigurationId String
#
#       new AutoScalingGroup
#         AutoScalingGroupName: 'ECS t2.micro'
#         MaxSize: 1
#         MinSize: 1
#         AvailabilityZones: ['STRING_VALUE']
#         LaunchConfigurationName: 'STRING_VALUE'
#         LoadBalancerNames: ['STRING_VALUE']
#         Tags: []
