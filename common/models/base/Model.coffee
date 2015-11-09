class @Model
  _mapping: null

  # Merges the properties of the `source` object into this model, applying any transformations
  # defined in the `mapping` object. If no `mapping` is provided, this object's `mapping` field will
  # be used as the default.
  mapMerge: (source, mapping) ->
    mapping ?= @_mapping
    unless mapping? then log.warn "No mapping to merge", source, "into", @

    for sourceKey of source
      sourceValue = Objects.getModifierProperty(source, sourceKey)
      destKey = mapping?[sourceKey] ? sourceKey

      if typeof destKey == 'string' then Objects.setModifierProperty @, destKey, sourceValue
      # If the destination key is a function, apply it and let it write the correct property.
      else if typeof destKey == 'function' then destKey(@, sourceValue)
    @

  constructor: (source) -> @mapMerge source
