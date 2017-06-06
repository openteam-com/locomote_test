datesTabs = -> $('#dates-tabs')
tabContents = -> $('#tab-content')
errorsWrapper = -> $('#errors')

append = (target, content) ->
  $(target).append(content)

activateTabs = ->
  $(datesTabs()).find('a').click (e) ->
    e.preventDefault()
    $(this).tab('show')

makeHtml = (tagName, content='', options={}) ->
  optionsArray = []
  for key, value of options
    optionsArray.push "#{key}='#{value}'"
  optionsString = optionsArray.join(' ')
  "<#{tagName} #{optionsString}>#{content}</#{tagName}>"

renderTab = (date, index) ->
  tabClass = if index == 2 then 'active' else ''
  link = makeHtml('a', "#{date}", { href: "##{date}","aria-controls": date, 'data-toggle': 'tab', role: 'tab' })
  tab = makeHtml('li', link, {role: "presentation", class: tabClass })
  append datesTabs(), tab

renderTabContent = (date, flights, index) ->
  content = renderFlights(flights)
  divClass = 'tab-pane fade'
  divClass += ' in active' if index == 2
  div = makeHtml 'div', content, {role: 'tabpanel', class: divClass, id: date}
  append tabContents(), div

renderFlights = (flights) ->
  flights
    .map (flight) ->
      header = renderFlightHeader(flight)
      body = renderFlightBody(flight)
      makeHtml('div', (header+body), class: 'panel panel-default')
    .join('')

renderFlightHeader = ({start, finish, durationMin, price}) ->
  startTime = prettyDate(start.dateTime)
  finishTime = prettyDate(finish.dateTime)
  priceSpan = makeHtml 'strong', "€#{price}", class: 'pull-right'
  timeInfoString = "#{startTime} - #{finishTime}, #{prettyFlightDuration(durationMin)} in flight"
  timeInfoSpan = makeHtml('span', timeInfoString)
  makeHtml 'div', timeInfoSpan + priceSpan, class: 'panel-heading'

prettyDate = (dateString) ->
  time = makeHtml 'strong', parseDate(dateString, 'h:mm a' )
  date = makeHtml 'small', parseDate(dateString, 'MMMM DD YYYY' )
  "#{time}, #{date}"

parseDate = (dateString, format='h:mm a, MMMM DD YYYY') ->
  moment(dateString).format(format)

prettyFlightDuration = (duration) ->
  milliseconds = moment.duration(duration * 60 * 1000)
  days = milliseconds.days()
  hours = milliseconds.hours()
  minutes = milliseconds.minutes()
  result = ''
  result += "#{days}d, " if days > 0
  result += "#{hours}h " if hours > 0 || days > 0
  result += "#{minutes}m"
  result

renderFlightBody = ({flightNum, plane, start, finish, airline}) ->
  aircompany = makeHtml('p', "#{airline.name} #{airline.code}", class: 'font-bold')
  start = makeHtml('span', "From: #{start.airportName} #{start.cityName}")
  finish = makeHtml('span', "To: #{finish.airportName} #{finish.cityName}")
  planeInfo = makeHtml('span', "Flight № #{flightNum}, #{plane.shortName}", class: 'pull-right')
  makeHtml 'div', "#{aircompany}#{start} - #{finish}#{planeInfo}", class: 'panel-body'

renderErrors = (errors) ->
  errors.map (error) ->
    message = makeHtml('p', error, class: "bg-danger")
    append errorsWrapper(), message

@renderResults = (dates) ->
  datesTabs().empty()
  tabContents().empty()
  if dates.errors
    renderErrors(dates.errors)
  else
    for {date, flights}, index in dates
      renderTab(date, index)
      renderTabContent(date, flights, index)
      activateTabs()
