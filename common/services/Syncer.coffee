# Manages syncing of data from services with Meteor collections.
@Syncer =

  # Syncs `docs` into `collection` and reports on the changes. If `complete` is `true`, then it is
  # assumed that `docs` represents all the docs that should be in the database. Any docs in the
  # database that are not in `docs` will be removed from the database.
  sync: (collection, docs, complete=false) ->
    log = (args...) -> console.log("[#{collection._name}]:", args...)

    if Meteor.isClient then return console.warn "Cannot sync data from client"
    unless docs and docs.length then return log "No docs"
    log "Syncing #{docs.length} docs..."

    # Add new docs.
    delta = for doc in docs
      collection.upsert doc._id, $set: doc
    count = delta.reduce ((z, d) -> z + (d.numAffected ? 0)), 0
    log if count > 0 then "Updated #{count} docs" else "No updates"

    # Remove obsolete docs.
    if complete
      count = collection.remove _id: $nin: (_.pluck docs, '_id')
      log if delta > 0 then "Removed #{count} docs" else "Nothing removed"
