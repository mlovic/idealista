module Idealista
  class QueryValidator
    # TODO look at hash_validator gem. implement rules?
    # TODO validate attribute type. Use key-value pair insted of just symbol?
    # TODO account for: {"error"=>"Invalid request. If you provide an address or a center coordinate you should also provide the radio or distance parameters", "error_code"=>42}
    PROPERTY_TYPES =  %i(homes bedrooms garages offices premises)
    REQUIRED_FIELDS = %i(property_type operation)
    LOCATION_FIELDS = %i(center address phone user_code) # TODO identifier fields? uniquefields?
    OPTIONAL_FIELDS = {
      common:   %i(distance radio num_page country max_items min_price max_price 
                   min_size max_size order sort since_date pictures 
                   professional_video), 
      # country? num_page? distance/radio?
      bedrooms: %i(no_smokers, gay_partners, no_pets_allowed, smoker, pets, sex, 
                   housemates),
      garages:  %i(security automatic_door motorcycle_parking)
    }

    def initialize(prop_type)
      if PROPERTY_TYPES.include?(prop_type)
        @type = prop_type
        @valid_fields = OPTIONAL_FIELDS[prop_type] + 
                        OPTIONAL_FIELDS[:common] + 
                        REQUIRED_FIELDS + 
                        LOCATION_FIELDS
        #@invalid_fields =    NOT YET
      else
        raise ArgumentError, 'Acceptable property types: homes, bedrooms, ' \
                             'garages, offices, premises'
      end
    end

    def validate(query)
      attributes = query.keys

      unless REQUIRED_FIELDS.all? { |e| attributes.include? e} && 
             (LOCATION_FIELDS & attributes).size == 1 
        raise ArgumentError, 'Required attributes: operation, property_type, ' \
                             'and only one of [center, address, phone, user_code]'
      end

      attributes.each do |e|
        unless @valid_fields.include? e
          raise ArgumentError, "Invalid query field: #{e}" 
        end
      end
    end

  end
end
