#= require init_datepicker
#= require form_handler
#= require init_location_autocomplete

initialize = ->
  @form_handler()
  @init_datepicker()
  @init_location_autocomplete()

$ -> initialize()
