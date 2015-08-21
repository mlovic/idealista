module Idealista 
  class Property
    # TODO all idealista attributes or only some? allow configure?
    # TODO Location class?
    attr_reader :price, :address, :bedrooms, :bathrooms, :description, :distance, :floor, :latitude, :longitude, :url

    def initialize(attributes = {})
      # add type argument
      # TODO block to try to add if exists
      @price = attributes['price']      
      @address = attributes['address']      
      @bathrooms = attributes['bathrooms']
      @bedrooms = attributes['bedrooms']
      @description = attributes['description']
      @distance = attributes['distance']
      @floor = attributes['floor']
      @latitude = attributes['latitude']
      @longitude = attributes['longitude']
      @url = attributes['url']
      # TODO create instance vars and attr_accessors with options hash
    end

    def coordinates
      [@latitude, @longitude]
    end
  end
end
