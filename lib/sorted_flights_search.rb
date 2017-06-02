require './lib/requester'

class SortedFlightsSearch
  def initialize(params)
    @params = params
  end


  def search
    flight_date = Date.parse @params[:date]
    date_range = flight_date.prev_day(2)..flight_date.next_day(2)

    threads = []
    result = []

    date_range.each do |date|
      flights = []
      airlines.each do |airline|
        airline_code = airline['code']
        @params.merge!(date: date)
        threads << Thread.new do
          request = Requester.new(api_method: "flight_search/#{airline_code}",
                                  params: { query: @params })
                             .parsed_body
          request.each { |flight| flights.push(flight) }
        end
      end
      result << { date: date, flights: flights }
    end

    threads.each(&:join)
    sort(result)
  end

  private

  def airlines
    @airlines ||= Requester.new(api_method: 'airlines').parsed_body
  end

  def sort(result)
    result.map do |date|
      date[:flights] = sort_flights(date[:flights])
      date
    end
  end

  def sort_flights(flights)
    flights.sort_by{|flight| flight['price']}
  end

end
