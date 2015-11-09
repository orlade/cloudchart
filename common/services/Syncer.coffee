# Manages syncing of data from services with Meteor collections.
@Syncer =

  # Syncs `docs` into `collection` and reports on the changes. If `complete` is `true`, then it is
  # assumed that `docs` represents all the docs that should be in the database. Any docs in the
  # database that are not in `docs` will be removed from the database.
  sync: Meteor.bindEnvironment (collection, docs, complete=false) ->
    # Helper function for logging with collection name prefix.
    slog = (args...) -> log.debug("[#{collection._name}]:", args...)

    if Meteor.isClient then return log.warn "Cannot sync data from client"
    unless docs and docs.length then return slog "No docs"
    slog "Syncing #{docs.length} docs..."

    # Add new docs.
    deltas = for doc in docs
      [mapping, doc._mapping] = [doc._mapping, undefined]
      delta = collection.upsert doc._id, $set: doc
      doc._mapping = mapping
      delta
    count = deltas.reduce ((z, d) -> z + (d.numAffected ? 0)), 0
    slog if count > 0 then "Updated #{count} docs" else "No updates"

    # Remove obsolete docs.
    if complete
      count = collection.remove _id: $nin: (_.pluck docs, '_id')
      slog if deltas > 0 then "Removed #{count} docs" else "Nothing removed"

  # Syncs data for the specfied services.
  syncService: (services) ->
    unless Array.isArray services then services  = [services]
    AwsSync.sync services

  # Syncs all service data. If on the client, delegates to the server via a Meteor method.
  syncAll: -> if Meteor.isServer then AwsSync.sync() else Meteor.call 'sync'
