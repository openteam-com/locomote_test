$ ->
  form = $('#flightForm')
  form.submit( (event) ->
    params = $(this).serialize()
    $.ajax
      url: "search?#{params}"
      success: (data) ->
        console.log data
    event.preventDefault()
  )

