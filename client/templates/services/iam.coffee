Template.iam.helpers
  roles: -> IAMRoles.find()
  roleItems: ->
    roles = [{
      label: "Suggestions"
      items: [
        {label: 'ecsInstanceRole', icon: 'cube', value: Blueprints.IAMRoles.ecsInstanceRole}
        {label: 'lambdaBasicExecution', icon: 'calculator', value: Blueprints.IAMRoles.lambdaBasicExecution}
      ]
    }]
    existing = _.pluck(IAMRoles.find({}, {fields: RoleName: true}).fetch(), 'RoleName')
    for g in [roles.length - 1..0]
      group = roles[g]
      # Remove any items that have the same name as an existing item.
      for i in [group.items.length - 1..0]
        if group.items[i].label in existing then group.items[i..i] = []
      if _.isEmpty group.items then roles[g..g] = []
    roles

  roleSchema: -> new SimpleSchema IAMRoleSchema

Template.iam.events
  'click .create.role .create.item': -> ModelFactory.create('IAMRole', @value).create()

Template.CreateMenu.onCreated ->
  @customHooks['role'] = (formValues, callback) -> ModelFactory.create('IAMRole', formValues).create(callback)

Template.IAMRoleTemplate.helpers
  manageUrl: -> "https://console.aws.amazon.com/iam/home?region=ap-southeast-2#roles/#{@RoleName}"
