ECS_ROOT_URL = 'https://ap-southeast-2.console.aws.amazon.com/ecs/home?region=ap-southeast-2'

Template.ecs.helpers
  installing: -> State.ecsConfigInstalling
  hasTasks: -> @tasks?.length

  taskdefFamilies: -> ECSService.taskdefs
  latestRevision: -> _.last _.values(@revisions)

  clusters: -> ECSService.clusters

  taskUrl: -> "#{ECS_ROOT_URL}#/clusters/default/tasks/#{@_id.split('/')[1]}"

Template.ecs.events
  'click .install.button': -> Meteor.call 'ecs/config/install'

  'click .scale.down.button': -> ECSService.scale @_id, @desiredCount - 1
  'click .scale.up.button': -> ECSService.scale @_id, @desiredCount + 1
