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
    distance = request["distance"]
    distance = 150 if distance == "NaN"
    googrequest = MapRequest.new("AIzaSyC7TuNaQTvLdE3A7wsdKAl4EMsZtrl0vhQ")

    #request restaurant
    response = googrequest.restaurants(latitude, longitude, distance).parsed_response
    if response["results"] == []
      haml :index, :locals => { :message => "There are no results in your area" }
    else
      result = response["results"].sample
      detailjson = googrequest.details(result["place_id"]).parsed_response
      website = detailjson["result"]["website"] || nil
      formatted_address = detailjson["result"]["formatted_address"].gsub(" ", "+")
      haml :display_results, :locals => { :result => result, :website => website, :latitude => latitude, :longitude => longitude, :formatted_address => formatted_address, :distance => distance}
    end
  else
    haml :index, :locals => { :message => nil }
  end
end


