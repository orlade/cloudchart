Template.ec2.helpers
  instances: -> EC2Service.instances
  lcItems: ->
    # TODO: Display custom form to customise blueprint parameters.
    ecsMicro = Blueprints.EC2LaunchConfigurations.ecsMicro
      ecsConfigPath: 'cloudchart-config/ecs/ecs.config'

    [{
      label: "Suggestions"
      items: [{label: ecsMicro.name, icon: 'cube', value: ecsMicro}]
    }]
  lcSchema: -> EC2LaunchConfiguration.schema
  asgSchema: -> AutoScalingGroup.schema

Template.ec2.events
  'click .create.item': -> @value.create()

Template.CreateMenu.onCreated ->
  @customHooks['lc'] = (formValues, callback) ->
    new EC2LaunchConfiguration(formValues).create(callback)

Template.EC2InstanceTemplate.helpers
  contractType: -> if @spot? then 'Spot' else 'On-Demand'
  manageUrl: -> "https://#{@region}.console.aws.amazon.com/ec2/v2/home?region=#{@region}#Instances:search=#{@_id};sort=instanceId"
  elbUrl: -> "https://#{@region}.console.aws.amazon.com/ec2/autoscaling/home?region=#{@region}#AutoScalingGroups:id=#{@autoscaleGroup};view=details"
  launchedAgo: -> moment(@LaunchTime).fromNow()
