Template.ec2.helpers
  instances: -> EC2Service.instances
  lcItems: -> [{
      name: "Suggestions"
      items: [{name: 'Micro', icon: 'cube'}]
    }]
  lcSchema: -> new SimpleSchema
    name:
      type: String,
      label: "Name",
      max: 50

Template.ec2.events
  'click .create.lc .create.item': -> new EC2LaunchConfiguration(@).create()

Template.CreateMenu.onCreated ->
  @customHooks['lc'] = (formValues, callback) ->
    new EC2LaunchConfiguration(formValues).create(callback)

Template.EC2InstanceTemplate.helpers
  contractType: -> if @spot? then 'Spot' else 'On-Demand'
  manageUrl: -> "https://#{@region}.console.aws.amazon.com/ec2/v2/home?region=#{@region}#Instances:search=#{@_id};sort=instanceId"
  elbUrl: -> "https://#{@region}.console.aws.amazon.com/ec2/autoscaling/home?region=#{@region}#AutoScalingGroups:id=#{@autoscaleGroup};view=details"
  launchedAgo: -> moment(@LaunchTime).fromNow()
