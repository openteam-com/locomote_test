@init_datepicker = ->
  $(".datepicker").datepicker(
    dateFormat: "yy-mm-dd"
    minDate: 0
  )
