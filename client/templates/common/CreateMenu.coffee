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
  # Handles a click of the Custom item by displaying the modal provided to the template. If the
  # modal contains a form (as expected), when the form is submitted the template handler will invoke
  # a `customHook` indexed by the `type`. Parent forms can register callbacks in using
  # `Template.CreateMenu.onCreated -> @customHook[<type>] = (formValues, callback -> ...)`.
  @modal = @$(".#{@data.type}.modal")
  @form = @$("form", @modal)
  @modal.modal({onHide: => @form?.form('clear')})

  # TODO: Figure out why form seems to submit twice when pressing enter without breakpoints.
  @form?.submit (event) =>
    # Stop the form from actually submitting and refreshing the page.
    event.preventDefault()
    hook = @customHooks[@data.type]
    if hook
      # Helper functions to pause and resume interactivity of the form after submission.
      disable = => @form.find('.field, button').addClass('disabled')
      enable = (err, res) =>
        log.error(err) if err
        @form.find('.field, button').removeClass('disabled')

      disable()
      try hook @form.form('get values'), enable
      catch ex then enable(ex)
    else log.warn "No hook for submitting #{@data.type} form"

Template.CreateMenu.helpers
  # Returns whether to render a divider after the current item.
  divide: (allItems) -> @customSchema or _.last(allItems) != @

  # Returns `'disabled'` if the menu button should be disabled, or `''` otherwise.
  disabled: -> if not @customSchema and _.isEmpty @items then 'disabled' else ''

  formId: -> "#{@type}CustomForm"

Template.CreateMenu.events
  'click .custom.item': (event, template) -> template.modal.modal('show')
