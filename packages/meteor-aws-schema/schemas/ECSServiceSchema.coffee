# https://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/ECS.html#describeServices-property
ECSServiceSchema =
  serviceArn:
    type: String
    description: "The Amazon Resource Name (ARN) that identifies the service. The ARN contains the arn:aws:ecs namespace, followed by the region of the service, the AWS account ID of the service owner, the service namespace, and then the service name. For example, arn:aws:ecs:region:012345678910:service/my-service."

  serviceName:
    type: String
    description: "A user-generated string that you can use to identify your service."

  clusterArn:
    type: String
    description: "The Amazon Resource Name (ARN) of the of the cluster that hosts the service."

  loadBalancers:
    type: [Object]
    blackbox: true
    description: "A list of load balancer objects, containing the load balancer name, the container name (as it appears in a container definition), and the container port to access from the load balancer."

    # loadBalancerName:
    #   type: String
    #   description: "The name of the load balancer."
    #
    # containerName:
    #   type: String
    #   description: "The name of the container to associate with the load balancer."
    #
    # containerPort:
    #   type: Number
    #   decimal: false
    #   description: "The port on the container to associate with the load balancer. This port must correspond to a containerPort in the service's task definition. Your container instances must allow ingress traffic on the hostPort of the port mapping."

  status:
    type: String
    description: "The status of the service. The valid values are ACTIVE, DRAINING, or INACTIVE."

  desiredCount:
    type: Number
    decimal: false
    description: "The desired number of instantiations of the task definition to keep running on the service. This value is specified when the service is created with CreateService, and it can be modified with UpdateService."

  runningCount:
    type: Number
    decimal: false
    description: "The number of tasks in the cluster that are in the RUNNING state."

  pendingCount:
    type: Number
    decimal: false
    description: "The number of tasks in the cluster that are in the PENDING state."

  taskDefinition:
    type: String
    description: "The task definition to use for tasks in the service. This value is specified when the service is created with CreateService, and it can be modified with UpdateService."

  deployments:
    type: [Object]
    blackbox: true
    description: "The current state of deployments for the service."

    # id:
    #   type: String
    #   description: "The ID of the deployment."
    #
    # status:
    #   type: String
    #   description: "The status of the deployment. Valid values are PRIMARY (for the most recent deployment), ACTIVE (for previous deployments that still have tasks running, but are being replaced with the PRIMARY deployment), and INACTIVE (for deployments that have been completely replaced)."
    #
    # taskDefinition:
    #   type: String
    #   description: "The most recent task definition that was specified for the service to use."
    #
    # desiredCount:
    #   type: Number
    #   decimal: false
    #   description: "The most recent desired count of tasks that was specified for the service to deploy or maintain."
    #
    # pendingCount:
    #   type: Number
    #   decimal: false
    #   description: "The number of tasks in the deployment that are in the PENDING status."
    #
    # runningCount:
    #   type: Number
    #   decimal: false
    #   description: "The number of tasks in the deployment that are in the RUNNING status."
    #
    # createdAt:
    #   type: Date
    #   description: "The Unix time in seconds and milliseconds when the service was created."
    #
    # updatedAt:
    #   type: Date
    #   description: "The Unix time in seconds and milliseconds when the service was last updated."

  roleArn:
    type: String
    description: "The Amazon Resource Name (ARN) of the IAM role associated with the service that allows the Amazon ECS container agent to register container instances with a load balancer."

  events:
    type: [Object]
    blackbox: true
    description: "The event stream for your service. A maximum of 100 of the latest events are displayed."

    # id:
    #   type: String
    #   description: "The ID string of the event."
    #
    # createdAt:
    #   type: Date
    #   description: "The Unix time in seconds and milliseconds when the event was triggered."
    #
    # message:
    #   type: String
    #   description: "The event message."

  failures:
    type: [Object]
    blackbox: true

# TODO: Refactor into schema.
ModelFactory.registerMapping 'ECSService',
  serviceArn: '_id'
  serviceName: 'name'
  taskDefinition: (service, tdArn) -> service.taskdefName = _.last tdArn.split('/')
