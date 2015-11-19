# The purpose of this global object is to provide a facade that unifies the two common use cases of
# recording the state of operations that affect multiple parts of the app, and performing reactive
# logic when properties of that state change.
#
# In order for changes to be recorded on both client and server sides, they are ultimately written
# to a collection that is published to the client. Since the syntax for reading from a collection is
# quite verbose in this simple case of a singleton document, the `State` object hides where the data
# is actually being read from.

# An object providing a facade to the global application state properties.
@State = {}

# The ID of the document for global state in the collection.
GLOBAL_STATE_ID = 'global'

# Values that should be set when the server side of the app starts up.
DEFAULT_VALUES =
  syncing: false
  ec2Syncing: 0
  ecsSyncing: 0
  s3Syncing: 0
  ecsConfigInstalling: false

# The collection backing the State object.
@StateCollection = new Mongo.Collection 'state'
StateCollection.allow({update: -> true})

# Ensure a known global configuration document exists
if Meteor.isServer then StateCollection.upsert GLOBAL_STATE_ID, DEFAULT_VALUES

# Publish and subscribe to the collection.
if Meteor.isServer then Meteor.publish 'state', -> StateCollection.find(GLOBAL_STATE_ID)
else Meteor.subscribe 'state'

# Set up reactive getters and setters on the `State` object to abstract the collection.
_.each DEFAULT_VALUES, (value, key) ->
  Object.defineProperty State, key,
    # Collection lookup is reactive. Elvis operator defends against collection not being ready yet.
    get: -> StateCollection.findOne(GLOBAL_STATE_ID)?[key]
    set: (value) ->
      # log.debug "Setting #{key} to #{value}..."
      modifier = {}
      modifier[key] = value
      StateCollection.update(GLOBAL_STATE_ID, $set: modifier)

# Helper function to write a delta of {key: value} pairs into the `State` object.
setAll = (delta) -> _.each delta, (value, key) -> State[key] = value

# Keep the state dictionary up to date on both client and server.
StateCollection.after.insert (userId, doc) -> setAll(doc)
StateCollection.after.update (userId, doc, fieldNames, modifier, options) -> setAll(modifier)
StateCollection.after.remove (userId, doc) -> log.debug "Removed doc", doc
