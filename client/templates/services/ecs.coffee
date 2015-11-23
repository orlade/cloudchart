ECS_ROOT_URL = 'https://ap-southeast-2.console.aws.amazon.com/ecs/home?region=ap-southeast-2'


Template.ecs.helpers
  installing: -> State.ecsConfigInstalling
  clusters: -> ECSClusters.find()

Template.TaskDefinitionsTemplate.helpers
  taskdefFamilies: -> ECSSyncService.taskdefs
  latestRevision: -> _.last _.values(@revisions)
  manageUrl: -> "#{ECS_ROOT_URL}#/taskDefinitions/#{@family}/#{@revision}"

Template.ECSClusterTemplate.helpers
  manageUrl: -> "#{ECS_ROOT_URL}#/clusters/#{getClusterName(@_id)}/services"
  # services: -> ECSServices.find({})

Template.ECSServiceTemplate.helpers
  manageUrl: -> "#{ECS_ROOT_URL}#/clusters/#{getClusterName(@_id)}/services/#{@name}/tasks"
  loadBalancerNames: -> _.pluck(@loadBalancerName, 'loadBalancerName').join(', ')

Template.ECSTaskTemplate.helpers
  manageUrl: -> "#{ECS_ROOT_URL}#/clusters/#{getClusterName(@_id)}/tasks/#{@taskId}"


Template.ecs.events
  'click .install.button': -> Meteor.call 'ecs/config/install'

  'click .scale.down.button': -> ECSSyncService.scale @_id, @desiredCount - 1
  'click .scale.up.button': -> ECSSyncService.scale @_id, @desiredCount + 1

# Utility methods

getClusterName = (clusterArn) -> clusterArn?.match(/\w+\/(\w+)/)[1]
