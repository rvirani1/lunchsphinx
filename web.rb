require 'sinatra'
require 'json'
require 'haml'
require 'httparty'
require 'pp'
require './lib/restaurantrequest.rb'
require './lib/environment.rb'

configure do
  enable :sessions
  set :server, :puma
  set(:session_secret, '91d9be49394ffe1bbe94c89d9cd3945e')
end

get '/' do
  haml :index
end

get '/randomrestaurant' do
  #Set distance to 800 meters if distance is actually not a number. Assuming people walk 80 meters a minute
  if request["distance"] == "NaN"
    distance = 800
  else
    distance = request["distance"].to_i * 80
  end
  #get restaurant request object from google
  google = RestaurantRequest.new(ENV['GOOGLE_API_KEY'])
  restaurant = google.random_restaurant :latitude => request["latitude"], :longitude => request["longitude"], :distance => distance
  #redirect to index if there were no results
  unless restaurant
    session[:flash] = "There are no results in your area"
    redirect to('/')
  end
  haml :display_results, :locals => { :restaurant => restaurant }
end

get '/:placeid/details.json' do
  content_type :json
  google = RestaurantRequest.new ENV["GOOGLE_API_KEY"]
  details= google.return_details(params[:placeid])
  details.to_json
end

helpers do
  def formatted_address(restaurant)
    restaurant["formatted_address"].gsub(" ", "+")
  end
end




