# A simple base class for all AWS model classes to extend. AWS Models are, as much as possible,
# plain old CoffeeScript objects, essentially pure data beans, operated on by other objects. This
# allows them to be used as data structures for forms and API requests, validated easily, and
# generally reduce the complexity of the application.
class AWSModel
  # Override in subclasses to use in methods.
  _type: "Model"

  constructor: (source) ->
    @userId = Meteor.userId()
    ModelMapper.merge @, source
