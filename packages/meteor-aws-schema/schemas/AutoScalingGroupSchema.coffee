AutoScalingGroupSchema =
  AutoScalingGroupName:
    optional: false
    type: String
    description: "The name of the group."

  AutoScalingGroupARN:
    type: String
    description: "The Amazon Resource Name (ARN) of the group."

  LaunchConfigurationName:
    optional: false
    type: String
    description: "The name of the associated launch configuration."

  MinSize:
    optional: false
    type: Number
    decimal: false
    description: "The minimum size of the group."

  MaxSize:
    optional: false
    type: Number
    decimal: false
    description: "The maximum size of the group."

  DesiredCapacity:
    optional: false
    type: Number
    decimal: false
    description: "The desired size of the group."

  DefaultCooldown:
    optional: false
    type: Number
    decimal: false
    description: "The number of seconds after a scaling activity completes before any further scaling activities can start."

  AvailabilityZones:
    optional: false
    type: [String]
    description: "One or more Availability Zones for the group."

  LoadBalancerNames:
    type: [String]
    description: "One or more load balancers associated with the group."

  HealthCheckType:
    optional: false
    type: String
    description: "The service of interest for the health status check, which can be either EC2 for Amazon EC2 or ELB for Elastic Load Balancing."

  HealthCheckGracePeriod:
    type: Number
    decimal: false
    description: "The amount of time that Auto Scaling waits before checking an instance's health status. The grace period begins when an instance comes into service."

  Instances:
    type: [Object]
    blackbox: true
    description: "The EC2 instances associated with the group."

    # InstanceId:
    #   optional: false
    #   type: String
    #   description: "The ID of the instance."
    #
    # AvailabilityZone:
    #   optional: false
    #   type: String
    #   description: "The Availability Zone in which the instance is running."
    #
    # LifecycleState:
    #   optional: false
    #   type: String
    #   description: "A description of the current lifecycle state. Note that the Quarantined state is not used."
    #   allowedValues: [
    #     "Pending"
    #     "Pending:Wait"
    #     "Pending:Proceed"
    #     "Quarantined"
    #     "InService"
    #     "Terminating"
    #     "Terminating:Wait"
    #     "Terminating:Proceed"
    #     "Terminated"
    #     "Detaching"
    #     "Detached"
    #     "EnteringStandby"
    #     "Standby"
    #   ]
    #
    # HealthStatus:
    #   optional: false
    #   type: String
    #   description: "The health status of the instance."
    #
    # LaunchConfigurationName:
    #   optional: false
    #   type: String
    #   description: "The launch configuration associated with the instance."

  CreatedTime:
    optional: false
    type: Date
    description: "The date and time the group was created."

  SuspendedProcesses:
    type: [Object]
    blackbox: true
    description: "The suspended processes associated with the group."

    # ProcessName:
    #   type: String
    #   description: "The name of the suspended process."
    #
    # SuspensionReason:
    #   type: String
    #   description: "The reason that the process was suspended."

  PlacementGroup:
    type: String
    description: "The name of the placement group into which you'll launch your instances, if any. For more information, see Placement Groups in the Amazon Elastic Compute Cloud User Guide."

  VPCZoneIdentifier:
    type: String
    description: "One or more subnet IDs, if applicable, separated by commas."

    description: "If you specify VPCZoneIdentifier and AvailabilityZones, ensure that the Availability Zones of the subnets match the values for AvailabilityZones."

  EnabledMetrics:
    type: [Object]
    blackbox: true
    description: "The metrics enabled for the group."

    # Metric:
    #   type: String
    #   description: "One of the following metrics"
    #   allowedValues: [
    #     'GroupMinSize'
    #     'GroupMaxSize'
    #     'GroupDesiredCapacity'
    #     'GroupInServiceInstances'
    #     'GroupPendingInstances'
    #     'GroupStandbyInstances'
    #     'GroupTerminatingInstances'
    #     'GroupTotalInstances'
    #   ]
    #
    # Granularity:
    #   type: String
    #   description: "The granularity of the metric. The only valid value is 1Minute."

  Status:
    type: String
    description: "The current state of the group when DeleteAutoScalingGroup is in progress."

  Tags:
    type: [Object]
    blackbox: true
    description: "The tags for the group."

  TerminationPolicies:
    type: [String]
    description: "The termination policies for the group."

  # Common helper properties.
  name:
    type: String

# TODO: Refactor into schema.
ModelFactory.registerMapping 'AutoScalingGroup',
  AutoScalingGroupName: 'name'
