
module Idealista 
  class Property
    # TODO all idealista attributes or only some? allow configure?
    attr_reader :price, :address, :bedrooms, :bathrooms, :description, :distance, :floor

    def initialize(attributes = {})
      # add type argument
      # TODO block to try to add if exists
      @price = attributes["price"]      
      @address = attributes["address"]      
      @bathrooms = attributes["bathrooms"]
      @bedrooms = attributes['bedrooms']
      @description = attributes["description"]
      @distance = attributes["distance"]
      @floor = attributes["floor"]
      @latitude = attributes["latitude"]
      @longitude = attributes["longitude"]
      # TODO create instance vars and attr_accessors with options hash
      # temporary rescue
    end

    def coordinates
      [@latitude, @longitude]
    end
  end
end


#class Property
#
  #def distance(coord)
    #Haversine.distance(coord, @location.coordinates).to_m
  #end

  #to_s?
  #def print(location) # = nil
    #raise ArgumentError unless location.class.name == NilClass or Location
    #format = "dist: %-3dm %24s %5d %s"
    #puts format % [distance(location.coordinates).round(0), coordinates.join(", "), @price, @address]
  #end

#end
