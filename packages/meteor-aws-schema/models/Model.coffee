class AWSModel
  # Override in subclasses to use in methods.
  _type: "Model"
  _collection: null
  _createMethod: null

  _mapping: null

  constructor: (source, @userId) ->
    @userId ?= Meteor.userId()
    @mapMerge source

  # Saves the model into the app database. Requires that the `_id` and `userId` be set.
  save: ->
    check @_id, String
    check userId, String
    check @_collection, Object

    @_collection.upsert @_id, @

  # Requests the creation in AWS of the entity represented by this object. Calls a Meteor method
  # since creation can only happen server-side.
  create: (callback) ->
    if @_id? then log.warn "Creating #{@_type} with existing ID #{@_id}"
    if @_methods?.create
      log.debug "Creating #{@_type}", @
      callback ?= (err, res) ->
        if err then log.error "Error creating new #{@_type}", err
      Meteor.call @_methods.create, @.toJSON(), callback
    else
      error = new Error "Create not implemented for #{@_type}"
      if callback then callback error else throw error

  # Merges the properties of the `source` object into this model, applying any transformations
  # defined in the `mapping` object. If no `mapping` is provided, this object's `mapping` field will
  # be used as the default.
  mapMerge: (source, mapping) ->
    mapping ?= @_mapping
    unless mapping? then log.warn "No mapping to merge", source, "into", @

    write = (key, value) =>
      if typeof key == 'string' then Objects.setModifierProperty @, key, value
      # If the destination key is a function, apply it and let it write the correct property.
      else if typeof key == 'function' then key(@, value)

    # Save each of the properties of the source object.
    for sourceKey of Objects.flattenProperties source
      # Save the original value.
      sourceValue = Objects.getModifierProperty(source, sourceKey)
      write sourceKey, sourceValue

      # If there is a key mapping defined, save the value under the mapped key as well.
      mappedKey = mapping?[sourceKey]
      if mappedKey? then write mappedKey, sourceValue
    @

  # Filter out the properties of this object that shouldn't be persisted.
  toJSON: ->
    filter = (key, value) ->
      if key[0] == '_' and key != '_id' then return false
      if key in ['userId', 'icon'] then return false
      true

    json = {}
    for key, value of @ when filter(key, value)
      json[key] = value
    json
