class RestaurantRequest
  include HTTParty
  attr_reader :latitude, :longitude, :distance, :restaurant, :details
  base_uri 'https://maps.googleapis.com/maps/api/place/'

  def initialize(apikey)
    @apikey = apikey
  end

  def random_restaurant(hash)
    @latitude  = hash[:latitude]
    @longitude = hash[:longitude]
    @distance  = hash[:distance]
    options    = {
      query:
        {
          :location => "#{latitude},#{longitude}",
          :radius => distance.to_s,
          :types => "food",
          :opennow => "true",
          :key => @apikey
        },
      verify: false
    }
    @restaurants = self.class.get('/nearbysearch/json', options)
    set_random_restaurant
    return nil if no_restaurants?
    return_details
  end

  def set_random_restaurant
    @restaurant = @restaurants["results"].sample
  end

  def no_restaurants?
    @restaurants["results"] == []
  end

  def return_details(placeid = @restaurant["place_id"])
    options = {query: { key: @apikey, placeid: placeid }, verify: false }
    self.class.get('/details/json', options)["result"]
  end
end
