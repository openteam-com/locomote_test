#= require html_renderers
renderResults = @renderResults

submitCallback = (event) ->
  event.preventDefault()
  params = $(this).serialize()
  # params = "from=DME&to=LHR&date=2017-06-13"

  $.ajax
    url: "search?#{params}"
    success: succesCallback
    beforeSend: beforeSendCallback

succesCallback = (data) ->
  renderResults(data)
  $('.js-loader').toggle()
  $('.js-content').toggle()

beforeSendCallback = ->
  $('.js-loader').toggle()
  $('.js-content').toggle()

@form_handler = ->
  form = $('#flightForm')
  form.submit submitCallback
