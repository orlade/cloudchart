@StateCollection = new Mongo.Collection 'state'

# Ensure a known global configuration document exists.
GLOBAL_STATE_ID = 'global'
DEFAULT_VALUES =
  syncing: false
  ecsConfigInstalling: false
if Meteor.isServer then StateCollection.upsert GLOBAL_STATE_ID, DEFAULT_VALUES

# An object providing a facade to the global application state properties.
@State = {}

# Set up reactive getters and setters on the `State` object to abstract the collection.
for name in _.keys DEFAULT_VALUES
  Object.defineProperty State, name,
    # Elvis operator defends against collection not being ready yet.
    get: -> StateCollection.findOne(GLOBAL_STATE_ID)?[name]
    set: (value) ->
      doc = {}
      doc[name] = value
      StateCollection.update(GLOBAL_STATE_ID, $set: doc)
