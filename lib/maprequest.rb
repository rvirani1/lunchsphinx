class MapRequest
  include HTTParty
  base_uri 'https://maps.googleapis.com/maps/api/place/'

  def initialize(apikey)
    @options = { query: {key: apikey}}
  end

  def restaurants(latitude, longitude)
    options = @options.clone
    options[:query].merge!({:location => "#{latitude},#{longitude}", radius: 300, types: "food", opennow: "true"})
    self.class.get('/nearbysearch/json', options)
  end

  def details(place_id)
    options = @options.clone
    options[:query].merge!({:placeid => place_id})
    self.class.get('/details/json',options)
  end
end