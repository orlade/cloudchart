# https://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/EC2.html#describeInstances-property
EC2InstanceSchema =
  InstanceId:
    type: String
    description: "The ID of the instance."

  ImageId:
    type: String
    description: "The ID of the AMI used to launch the instance."

  State:
    type: Object
    blackbox: true
    description: "The current state of the instance."

    # Code:
    #   type: Number
    #   decimal: false
    #   description: "The low byte represents the state. The high byte is an opaque internal value and
    #       should be ignored."
    #
    # Name:
    #   type: String
    #   description: "The current state of the instance."
    #   allowedValues: [
    #     "pending"
    #     "running"
    #     "shutting-down"
    #     "terminated"
    #     "stopping"
    #     "stopped"
    #   ]

  PrivateDnsName:
    type: String
    description: "The private DNS name assigned to the instance. This DNS name can only be used
        inside the Amazon EC2 network. This name is not available until the instance enters the
        running state. For EC2-VPC, this name is only available if you've enabled DNS hostnames for
        your VPC."

  PublicDnsName:
    type: String
    description: "The public DNS name assigned to the instance. This name is not available until the
        instance enters the running state. For EC2-VPC, this name is only available if you've
        enabled DNS hostnames for your VPC."

  StateTransitionReason:
    type: String
    description: "The reason for the most recent state transition. This might be an empty string."

  KeyName:
    type: String
    description: "The name of the key pair, if this instance was launched with an associated key
        pair."

  AmiLaunchIndex:
    type: Number
    decimal: false
    description: "The AMI launch index, which can be used to find this instance in the launch
        group."

  ProductCodes:
    type: [Object]
    blackbox: true
    description: "The product codes attached to this instance, if applicable."

    # ProductCodeId:
    #   type: String
    #   description: "The product code."
    #
    # ProductCodeType:
    #   type: String
    #   description: "The type of product code."
    # Possible values include:
    # "devpay"
    # "marketplace"

  InstanceType:
    type: String
    description: "The instance type."

  LaunchTime:
    type: Date
    description: "The time the instance was launched."

  Placement:
    type: Object
    blackbox: true
    description: "The location where the instance launched, if applicable."

  AvailabilityZone:
    type: String
    description: "The Availability Zone of the instance."

  GroupName:
    type: String
    description: "The name of the placement group the instance is in (for cluster compute instances)."

  Tenancy:
    type: String
    description: "The tenancy of the instance (if the instance is running in a VPC). An instance with a tenancy of dedicated runs on single-tenant hardware."
    allowedValues: [
      "default"
      "dedicated"
    ]

  KernelId:
    type: String
    description: "The kernel associated with this instance, if applicable."

  RamdiskId:
    type: String
    description: "The RAM disk associated with this instance, if applicable."

  Platform:
    type: String
    description: "The value is Windows for Windows instances; otherwise blank."
    allowedValues: ["Windows", ""]

  Monitoring:
    type: Object
    blackbox: true
    description: "The monitoring information for the instance."

  SubnetId:
    type: String
    description: "[EC2-VPC] The ID of the subnet in which the instance is running."

  VpcId:
    type: String
    description: "[EC2-VPC] The ID of the VPC in which the instance is running."

  PrivateIpAddress:
    type: String
    description: "The private IP address assigned to the instance."

  PublicIpAddress:
    type: String
    description: "The public IP address assigned to the instance, if applicable."

  StateReason:
    type: Object
    blackbox: true
    description: "The reason for the most recent state transition."

  Architecture:
    type: String
    description: "The architecture of the image."
    allowedValues: [
      "i386"
      "x86_64"
    ]

  RootDeviceType:
    type: String
    description: "The root device type used by the AMI. The AMI can use an EBS volume or an instance store volume."
    allowedValues: [
      "ebs"
      "instance-store"
    ]

  RootDeviceName:
    type: String
    description: "The root device name (for example, /dev/sda1 or /dev/xvda)."

  BlockDeviceMappings:
    type: [Object]
    blackbox: true
    description: "Any block device mapping entries for the instance."

  VirtualizationType:
    type: String
    description: "The virtualization type of the instance."
    allowedValues: [
      "hvm"
      "paravirtual"
    ]

  InstanceLifecycle:
    type: String
    description: "Indicates whether this is a Spot Instance."
    allowedValues: ["spot", ""]

  SpotInstanceRequestId:
    type: String
    description: "If the request is a Spot instance request, the ID of the request."

  ClientToken:
    type: String
    description: "The idempotency token you provided when you launched the instance, if applicable."

  Tags:
    type: [Object]
    blackbox: true
    description: "Any tags assigned to the instance."

  SecurityGroups:
    type: [Object]
    blackbox: true
    description: "One or more security groups for the instance."

  SourceDestCheck:
    type: Boolean
    description: "Specifies whether to enable an instance launched in a VPC to perform NAT. This controls whether source/destination checking is enabled on the instance. A value of true means checking is enabled, and false means checking is disabled. The value must be false for the instance to perform NAT. For more information, see NAT Instances in the Amazon Virtual Private Cloud User Guide."

  Hypervisor:
    type: String
    description: "The hypervisor type of the instance."
    allowedValues: [
      "ovm"
      "xen"
    ]

  NetworkInterfaces:
    type: [Object]
    blackbox: true
    description: "[EC2-VPC] One or more network interfaces for the instance."

  IamInstanceProfile:
    type: Object
    blackbox: true
    description: "The IAM instance profile associated with the instance, if applicable."

  EbsOptimized:
    type: Boolean
    description: "Indicates whether the instance is optimized for EBS I/O. This optimization provides dedicated throughput to Amazon EBS and an optimized configuration stack to provide optimal I/O performance. This optimization isn't available with all instance types. Additional usage charges apply when using an EBS Optimized instance."

  SriovNetSupport:
    type: String
    description: "Specifies whether enhanced networking is enabled."

  # Common helper properties.
  ip:
    type: String
  status:
    type: String
  spot:
    type: String
  region:
    type: String

# All properties sohuld be optional by default.
for key, value of EC2InstanceSchema
  value.optional ?= true

TAG_KEY_MAP =
  name: 'name'
  Name: 'name'
  'aws:autoscaling:groupName': 'autoscaleGroup'

# TODO: Refactor into schema.
ModelMapper.registerMapping 'EC2Instance',
  InstanceId: '_id'
  PublicIpAddress: 'ip'
  'State.Name': 'status'
  SpotInstanceRequestId: 'spot'
  'Placement.AvailabilityZone': (instance, az) -> instance.region = Region.azToRegion(az)
  Tags: (instance, tags) ->
    for {Key, Value} in tags when Key of TAG_KEY_MAP
      instance[TAG_KEY_MAP[Key]] = Value
