IAMRoleSchema =
  Arn:
    type: String
  RoleId:
    type: String
  RoleName:
    type: String
  Path:
    type: String
  AssumeRolePolicyDocument:
    type: Object
    blackbox: true

  # Custom helper properties.
  name:
    type: String

# TODO: Refactor into schema.
ModelMapper.registerMapping 'IAMRole',
  RoleName: 'name'
