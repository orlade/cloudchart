class @ECSService extends Model
  _mapping:
    serviceArn: '_id'
    serviceName: 'name'
    taskDefinition: (service, tdArn) -> service.taskdefName = _.last tdArn.split('/')
