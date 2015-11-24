ModelFactory =
  # Map of AWS model type to merge transformations. Each transformation is a `{key: value}` pair ,
  # mapping the source name to the preferred destination name.
  _mappings: {}

  # Creates a new model of the `type` from the `source` data. If `source` is an array of source
  # objects, returns an array of created models.
  create: (type, source, mapping, options) ->
    if Types.isArray source then (@create(type, item, mapping, options) for item in source)
    else @merge({_type: type}, source, mapping, options)

  registerMapping: (type, mapping) ->
    if @_mappings[type]? then log.warn "Mapping already registered for #{type}, overwriting..."
    @_mappings[type] = mapping

  # Merges the properties of the `source` object into the `dest` model, applying any transformations
  # defined in the `mapping` object. If no `mapping` is provided, the merge will use any suitable
  # mapping that has been previously registered with the mapper.
  #
  # `options` customises the behaviour of the function. The `deleteOriginals` option requests that
  # all transformed source properties are not saved with their original names alongside the
  # transformated names.
  merge: (dest, source, mapping, options) ->
    options ?= {}
    mapping ?= @_mappings[dest._type]
    unless mapping? then log.warn "No mapping to merge", source, "into", dest

    write = (key, value) =>
      if typeof key == 'string' then Objects.setModifierProperty dest, key, value
      # If the destination key is a function, apply it and let it write the correct property.
      else if typeof key == 'function' then key(dest, value)

    # Save each of the properties of the source object.
    for sourceKey of Objects.flattenProperties source
      # Save the original value unless requested not to.
      unless options.deleteOriginals
        sourceValue = Objects.getModifierProperty(source, sourceKey)
        write sourceKey, sourceValue

      # If there is a key mapping defined, save the value under the mapped key as well.
      if mapping?[sourceKey]? then write mapping[sourceKey], sourceValue
    dest
