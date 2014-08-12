require 'sinatra'
require 'pry'
require 'json'
require 'haml'
require 'httparty'
require 'pp'
require './lib/maprequest.rb'

configure do
  enable :sessions
end

configure :development do
  set(:session_secret, 'a random string that wont change')
end

configure :production do
  set(:session_secret, '*&(${)UIJH$(&*(&*(@(*)(!)))IUYA0984)})')
end

get '/' do
  if request["latitude"] && request["longitude"]
    latitude = request["latitude"]
    longitude = request["longitude"]
    googrequest = MapRequest.new("AIzaSyC7TuNaQTvLdE3A7wsdKAl4EMsZtrl0vhQ")
    response = googrequest.restaurants(latitude, longitude).parsed_response
    result = response["results"].sample
    urljson = googrequest.details(result["place_id"]).parsed_response
    url = urljson["result"]["url"]
    formatted_address = urljson["result"]["formatted_address"].gsub(" ", "+")
    haml :display_results, :locals => { :result => result, :url => url, :latitude => latitude, :longitude => longitude, :formatted_address => formatted_address}
  else
    haml :index
  end
end


