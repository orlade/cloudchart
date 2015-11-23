# https://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/ECS.html#describeClusters-property
ECSClusterSchema =
  clusterArn:
    type: String
    description: "The Amazon Resource Name (ARN) that identifies the cluster. The ARN contains the
        arn:aws:ecs namespace, followed by the region of the cluster, the AWS account ID of the
        cluster owner, the cluster namespace, and then the cluster name. For example,
        arn:aws:ecs:region:012345678910:cluster/test."

  clusterName:
    type: String
    description: "A user-generated string that you use to identify your cluster."

  status:
    type: String
    description: "The status of the cluster. The valid values are ACTIVE or INACTIVE. ACTIVE indicates
        that you can register container instances with the cluster and the associated instances can
        accept tasks."

  registeredContainerInstancesCount:
    type: Number
    decimal: false
    description: "The number of container instances registered into the cluster."

  runningTasksCount:
    type: Number
    decimal: false
    description: "The number of tasks in the cluster that are in the RUNNING state."

  pendingTasksCount:
    type: Number
    decimal: false
    description: "The number of tasks in the cluster that are in the PENDING state."

  activeServicesCount:
    type: Number
    decimal: false
    description: "The number of services that are running on the cluster in an ACTIVE state."

  # Standardized helper properties.
  name:
    type: String
  # services:
  #   type: [Object]
  #   blackbox: true

# TODO: Refactor into schema.
ModelMapper.registerMapping 'ECSCluster',
  clusterArn: '_id'
  clusterName: 'name'
