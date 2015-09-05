Template.ecs.helpers
  installing: -> State.ecsConfigInstalling

  taskdefs: -> ECSService.taskdefs
  services: -> ECSService.services
  clusters: -> ECSService.clusters

Template.ecs.events
  'click .install.button': (e) -> Meteor.call 'ecs/config/install'
