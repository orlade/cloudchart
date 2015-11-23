# Operations for reading and writing models from and to the database and the AWS API.
ModelCrud =
  # Saves the model into the app database.
  save: (model) -> AWSCollections[model._type].upsert model_id, model

  # Requests the creation in AWS of the entity represented by this object. Calls a Meteor method
  # since creation can only happen server-side.
  create: (model, callback) ->
    if model._id? then log.warn "Creating #{model._type} with existing ID #{model._id}"
    if @_methods?.create
      log.debug "Creating #{model._type}", model
      callback ?= (err, res) ->
        if err then log.error "Error creating new #{model._type}", err
      Meteor.call @_methods.create, model.toJSON(), callback
    else
      error = new Error "Create not implemented for #{model._type}"
      if callback then callback error else throw error

  # Filter out the properties of this object that shouldn't be persisted.
  toAwsJson: ->
    filter = (key, value) ->
      if key[0] == '_' and key != '_id' then return false
      if key in ['userId', 'icon'] then return false
      true

    json = {}
    for key, value of @ when filter(key, value)
      json[key] = value
    json

CREATE_METHODS:
  S3Bucket: 's3/createBucket'
  EC2LaunchConfiguration: 'ec2/createLaunchConfiguration'
