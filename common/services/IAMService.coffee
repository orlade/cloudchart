@IAMService =
  id: 'iam'
  name: 'IAM'

  _getApi: -> UserAWS('IAM')

  sync: ->
    iam = IAMService._getApi()
    State.iamSyncing++
    try IAMService.syncRoles(iam)
    finally State.iamSyncing--

  syncRoles: (iam) ->
    if Meteor.isClient then return log.warn "Cannot sync data from client"
    log.debug "Syncing IAM roles..."

    {Roles} = iam.listRolesSync()
    log.debug Roles
    roles = (new IAMRole(role) for role in Roles)
    Syncer.sync IAMRoles, roles, true
    log.debug "Finished syncing IAM roles"

  createRole: (iam, role) ->
    iam.createRoleSync _.pick(role, 'RoleName', 'AssumeRolePolicyDocument')

if Meteor.isServer
  Meteor.methods
    'iam/createRole': (role) ->
      iam = IAMService._getApi()
      State.iamSyncing++
      try
        data = IAMService.createRole(iam, role)
        log.debug "Created IAM role #{role.RoleName}", data
        IAMService.syncRoles(iam)
        data
      catch e then throw new Meteor.Error(e.statusCode, "#{e.code}: #{e.message}")
      finally State.iamSyncing--
