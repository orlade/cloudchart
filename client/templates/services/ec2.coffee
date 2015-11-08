Template.ec2.helpers
  instances: -> EC2Service.instances
  name: -> @Tags.filter((t) -> t.Key == 'Name')[0]?.Value ? '(unnamed)'
  autoscaleGroup: -> @Tags.filter((t) -> t.Key == 'aws:autoscaling:groupName')[0]?.Value
  contractType: -> if @spot? then 'spot' else 'non-spot'
  manageUrl: -> "https://#{@region}.console.aws.amazon.com/ec2/v2/home?region=#{@region}#Instances:search=#{@_id};sort=instanceId"
  statusColor: -> Status.getColor(@status) ? 'red'
