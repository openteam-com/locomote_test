require 'sinatra'
require 'sprockets'
require './lib/requester.rb'
require './lib/sorted_flights_search.rb'
require './helpers/main_helper.rb'

include MainHelper

set :public_folder, File.dirname(__FILE__) + '/public'
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
  result = search_params_present? ? SortedFlightsSearch.new(params).search : { errors: missing_params_error_messages  }
  result.to_json
end

# asset path
get "/assets/*" do
  env["PATH_INFO"].sub!("/assets", "")
  environment.call(env)
end
