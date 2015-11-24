ECSTaskSchema = {}

# TODO: Refactor into schema.
ModelFactory.registerMapping 'ECSTask',
  taskArn: (task, arn) ->
    task._id = arn
    task.taskId = _.last arn.split('/')
  lastStatus: 'status'
  containers: (task, containers) -> task.errors = (c.reason for c in containers when c.reason?)
  # Extract the task definition family and revision as the "name" of the task.
  taskDefinitionArn: (task, tdArn) -> task.name = _.last tdArn.split('/')
