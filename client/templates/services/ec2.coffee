Template.ec2.helpers
  instances: -> EC2Service.instances
  contractType: -> if @spot? then 'spot' else 'non-spot'
  manageUrl: -> "https://#{@region}.console.aws.amazon.com/ec2/v2/home?region=#{@region}#Instances:search=#{@_id};sort=instanceId"
