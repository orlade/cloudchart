@Blueprints =
  EC2LaunchConfigurations:
    ecsMicro: (args) ->
      check args.ecsConfigPath, String
      check args.iamRoleId, String
      # check args.securityGroupId String

      new EC2LaunchConfiguration
        LaunchConfigurationName: "ECS t2.micro"
        BlockDeviceMappings: [{DeviceName: 'xvda', Ebs: VolumeSize: 30}]
        EbsOptimized: false # Maybe true?
        IamInstanceProfile: args.iamRoleId
        ImageId: 'B00U6QTYI2'
        InstanceMonitoring: Enabled: false
        InstanceType: 't2.micro'
        # SecurityGroups: [args.securityGroupId] # TODO: Search/create
        UserData: "#!/bin/bash
yum install -y aws-cli
aws s3 cp s3://#{args.ecsConfigPath} /etc/ecs/ecs.config" # TODO: Search/create

#   AutoScalingGroups:
#     ecsMicro: (args) ->
#       check args.launchConfigurationId, String
#
#       new AutoScalingGroup
#         AutoScalingGroupName: 'ECS t2.micro'
#         MaxSize: 1
#         MinSize: 1
#         AvailabilityZones: ['STRING_VALUE']
#         LaunchConfigurationName: 'STRING_VALUE'
#         LoadBalancerNames: ['STRING_VALUE']
#         Tags: []

  IAMRoles:
    ecsInstanceRole: # (configBucket) -> # TODO: Parameterise in the config bucket name.
      RoleName: 'ecsInstanceRole'
      AssumeRolePolicyDocument: JSON.stringify
        "Version": "2012-10-17"
        "Statement": [{
          "Effect": "Allow"
          "Action": [
            "ecs:CreateCluster"
            "ecs:DeregisterContainerInstance"
            "ecs:DiscoverPollEndpoint"
            "ecs:Poll"
            "ecs:RegisterContainerInstance"
            "ecs:StartTelemetrySession"
            "ecs:Submit*"
            # Allow the instance to read S3 buckets to retrieve config scripts.
            "s3:Get*"
            "s3:List*"
          ]
          "Resource": ["*"]
        }]

    ecsServiceRole:
      RoleName: 'ecsServiceRole'
      AssumeRolePolicyDocument: JSON.stringify
        "Version": "2012-10-17"
        "Statement": [{
          "Effect": "Allow"
          "Action": [
            "elasticloadbalancing:Describe*"
            "elasticloadbalancing:DeregisterInstancesFromLoadBalancer"
            "elasticloadbalancing:RegisterInstancesWithLoadBalancer"
            "ec2:Describe*"
            "ec2:AuthorizeSecurityGroupIngress"
          ]
          "Resource": ["*"]
        }]

    lambdaBasicExecution:
      RoleName: 'lambdaBasicExecution'
      AssumeRolePolicyDocument: JSON.stringify
        "Version": "2012-10-17"
        "Statement": [{
          "Effect": "Allow"
          "Action": [
            "logs:CreateLogGroup"
            "logs:CreateLogStream"
            "logs:PutLogEvents"
          ]
          "Resource": ["*"]
        }]
