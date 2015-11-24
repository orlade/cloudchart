Template.ec2.helpers
  instances: -> EC2Service.instances
  lcItems: ->
    # TODO: Display custom form to customise blueprint parameters.
    roleArn = IAMRoles.findOne({RoleName: 'ecsInstanceRole'}, {fields: {Arn: true}})?.Arn
    if roleArn?
      ecsMicro = Blueprints.EC2LaunchConfigurations.ecsMicro
        ecsConfigPath: 'cloudchart-config/ecs/ecs.config'
        iamRoleId: roleArn

    [{
      label: "Suggestions"
      items: [{label: ecsMicro.name, icon: 'cube', value: ecsMicro}]
    }]
  lcSchema: -> EC2LaunchConfigurations.simpleSchema()
  asgSchema: -> AutoScalingGroups.simpleSchema()

Template.ec2.events
  'click .create.item': -> ModelFactory.create @value

Template.CreateMenu.onCreated ->
  @customHooks['lc'] = (formValues, callback) ->
    ModelCrud.create(ModelFactory.create('EC2LaunchConfiguration', formValues), callback)

Template.EC2InstanceTemplate.helpers
  contractType: -> if @spot? then 'Spot' else 'On-Demand'
  manageUrl: -> "https://#{@region}.console.aws.amazon.com/ec2/v2/home?region=#{@region}#Instances:search=#{@_id};sort=instanceId"
  elbUrl: -> "https://#{@region}.console.aws.amazon.com/ec2/autoscaling/home?region=#{@region}#AutoScalingGroups:id=#{@autoscaleGroup};view=details"
  launchedAgo: -> moment(@LaunchTime).fromNow()
