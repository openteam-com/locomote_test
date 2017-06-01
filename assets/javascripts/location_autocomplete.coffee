$ ->
  transformToAutocmpleteData = (data) ->
    data.map ({airportCode: code, airportName, cityName }) ->
      label = "#{airportName} #{cityName}"
      { code, label }

  $('.js-autocomplete').autocomplete(
    minLength: 2
    delay: 200
    source: (request, response) ->
      $.ajax
        url: 'airports'
        data: q: request.term
        success: (data) ->
          response transformToAutocmpleteData(data)
    select: (event, ui) ->
      $(this).next('.js-autocomplete-target').val(ui.item.code)
  )
