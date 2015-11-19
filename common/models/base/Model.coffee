class @Model
  _mapping: null

  constructor: (source, @userId) ->
    @userId ?= Meteor.userId()
    @mapMerge source

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
