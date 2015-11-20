# Manages syncing of data from services with Meteor collections.
@Syncer =

  # Syncs `models` into `collection` and reports on the changes. If `complete` is `true`, then it is
  # assumes that `models` represents all the docs that should be in the database. Any docs in the
  # database that are not in `models` will be removed from the database.
  sync: Meteor.bindEnvironment (collection, models, complete=false) ->
    # Helper function for logging with collection name prefix.
    slog = (args...) -> log.debug("[#{collection._name}]:", args...)

    if Meteor.isClient then return log.warn "Cannot sync data from client"
    unless models and models.length then return slog "No models"
    slog "Syncing #{models.length} models..."

    # Add new models.
    deltas = for model in models
      doc = collection.simpleSchema().clean(model)
      delta = collection.upsert(doc._id, {$set: doc}, {validate: false})?.numberAffected ? 0
      delta
    count = deltas.reduce ((z, d) -> z + d), 0
    slog if count > 0 then "Updated #{count} docs" else "No updates"

    # Remove obsolete docs.
    if complete
      count = collection.remove _id: $nin: (_.pluck models, '_id')
      slog if deltas > 0 then "Removed #{count} docs" else "Nothing removed"

  # Syncs data for the specfied services.
  syncService: (services) ->
    unless Array.isArray services then services  = [services]
    AwsSync.sync services

  # Syncs all service data. If on the client, delegates to the server via a Meteor method.
  syncAll: -> if Meteor.isServer then AwsSync.sync() else Meteor.call 'sync'
