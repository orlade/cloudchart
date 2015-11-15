Template.ec2.helpers
  instances: -> EC2Service.instances

Template.EC2InstanceTemplate.helpers
  contractType: -> if @spot? then 'Spot' else 'On-Demand'
  manageUrl: -> "https://#{@region}.console.aws.amazon.com/ec2/v2/home?region=#{@region}#Instances:search=#{@_id};sort=instanceId"
  elbUrl: -> "https://#{@region}.console.aws.amazon.com/ec2/autoscaling/home?region=#{@region}#AutoScalingGroups:id=#{@autoscaleGroup};view=details"
  launchedAgo: -> moment(@LaunchTime).fromNow()
