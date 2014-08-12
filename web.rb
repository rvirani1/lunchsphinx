require 'sinatra'
require 'pry'
require 'json'
require 'haml'
require 'httparty'
require 'pp'
require './lib/maprequest.rb'

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
    googrequest = MapRequest.new("AIzaSyCGX1_9TCoxTio-8I79KbIxwVPXtb9UP08")
    response = googrequest.restaurants(latitude, longitude).parsed_response
    result = response["results"].sample
    urljson = googrequest.details(result["place_id"]).parsed_response
    haml :display_results, :locals => { :result => result, :url => urljson["result"]["url"], :latitude => latitude, :longitude => longitude}
  else
    haml :index
  end
end


