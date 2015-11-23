global = @

AWSCollections = {}

AWSCollectionsConfig =
  # Initialize the collections using the configuration `options`.
  #
  # * `userId`: The modifier path for a property representing the user that owns the document in a
  #   collection. If provided, publications are filtered such that the current user only sees docs
  #   where this `userId` property is equal to the user's ID. If not provided, all docs are
  #   published.
  # * `models`: An array of names of models to create collections for. If `null`, collections will
  #   be created for all models.
  configure: (options) ->
    AWSModelNames.forEach (modelName) ->
      if options.models and modelName in options.models then return

      # Create each collection by (plural) name on client and server
      name = _pluralize modelName
      collection = new Mongo.Collection name
      global[name] = AWSCollections[name] = collection

      if SimpleSchema? and AWSSchemas[modelName]
        schema = AWSSchemas[modelName]
        schema._id = {type: String}
        if options.userId
          Objects.setModifierProperty(schema, options.userId, {type: String, label: "User ID"})
        collection.attachSchema new SimpleSchema(schema)

      # Publish on the server, subscribe on the client.
      if Meteor.isServer
        Meteor.publish name, ->
          query = {}
          if options.userId then query[options.userId] = @userId
          collection.find(query)
      else Meteor.subscribe name

_pluralize = (name) -> if _.last(name) == 'y' then name[0...-1] + 'ies' else name + 's'
