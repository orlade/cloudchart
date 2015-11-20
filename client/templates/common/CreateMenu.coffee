# The CreateMenu template defines a dropdown button menu for creating new entities.
#
# To handle the click events of items in the menu, use `Template.CreateMenu.events` in the parent
# template handler and register to the event `'click .create.type .create.item'`.
#
# * `type`: The class to add to the menu.
# * `label`: The label to display on the button.
# * `items` (`[{name, items: [{name, icon}]}]`): The items to display in the list.
# * `customModal`: The selector of `modal` to display when the Custom option is clicked. The custom
#   item will not be rendered unless this is provided.
Template.CreateMenu.onCreated ->
  # Map of menu entity type to callbacks to execute when a custom form is submitted. Callbacks of
  # the form `(formValues, (err, res) ->)`
  # TODO: Refactor form to a new template/class.
  @customHooks ?= {}

Template.CreateMenu.onRendered ->
  @data.customModal ?= $(".#{@data.type}.modal")
  $('.btn').addClass('ui button')

Template.CreateMenu.helpers
  # Returns whether to render a divider after the current item.
  divide: (allItems) -> @customModal or _.last(allItems) != @

  # Returns `'disabled'` if the menu button should be disabled, or `''` otherwise.
  disabled: -> if not @customModal and _.isEmpty @items then 'disabled' else ''

  formId: -> "#{@type}CustomForm"

  hasCustomModal: ->
    log.debug 'hascm', @customModal, $(".#{@type}.modal")
    @customModal or not _.isEmpty $(".#{@type}.modal")

Template.CreateMenu.events
  # Handles a click of the Custom item by displaying the modal provided to the template. If the
  # contains a form (as expected), when the form is submitted the template handler will invoke a
  # hook called `{{type}}FormSubmitted` on the `CreateMenu` template.
  'click .custom.item': (event, template) ->
    modal = $(".#{@type}.modal")
    form = $("form", modal)
    log.info @, arguments, form, modal
    modal.modal('show').modal({onHide: -> form?.form('clear')})
    form?.submit (e) =>
      e.preventDefault()
      hook = template.customHooks[@type]
      if hook
        form.find('.field, button').addClass('disabled')
        hook form.form('get values'), (err, res) ->
          log.error(err) if err
          form.find('.field, button').removeClass('disabled')
      else log.warn "No hook for submitting #{@type} form"
