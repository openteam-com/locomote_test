require 'sinatra'
require 'sprockets'
require './lib/requester.rb'

environment = Sprockets::Environment.new
environment.append_path "assets/stylesheets"
environment.append_path "assets/javascripts"
environment.js_compressor  = :uglify
environment.css_compressor = :sass

get "/" do
  erb :index
end

get "/airlines" do
  content_type :json

  Requester.new(api_method: 'airlines').body
end

get "/airports" do
  content_type :json

  Requester.new(api_method: 'airports', params: { query: params })
           .body
end

get "/search" do
  content_type :json

  airlines = JSON.parse Requester.new(api_method: 'airlines').body
  flight_date = Date.parse params[:date]
  date_range = flight_date.prev_day(2)..flight_date.next_day(2)

  threads = []
  result = {}

  date_range.each do |date|
    result[date] = {}
    airlines.each do |airline|
      airline_code = airline['code']
      params.merge!(date: date)
      threads << Thread.new do
        result[date][airline_code] = Requester.new(api_method: "flight_search/#{airline['code']}", params: { query: params }).parsed_body
      end
    end
  end

  threads.each(&:join)
  result.to_json
end

# asset path
get "/assets/*" do
  env["PATH_INFO"].sub!("/assets", "")
  environment.call(env)
end
