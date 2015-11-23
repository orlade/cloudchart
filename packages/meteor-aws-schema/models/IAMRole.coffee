class IAMRole extends AWSModel
  _type: "Role"
  _methods:
    create: 'iam/createRole'

  _mapping:
    RoleId: '_id'
    RoleName: 'name'

  constructor: ->
    @_collection = IAMRoles
    super arguments...
