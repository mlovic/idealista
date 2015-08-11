module Idealista
  class QueryValidator
    # TODO validate attribute type. Use key-value pair insted of just symbol?
    PROPERTY_TYPES =  %i(homes bedrooms garages offices premises)
    REQUIRED_FIELDS = %i(property_type operation)
    LOCATION_FIELDS = %i(center address phone user_code) # TODO identifier fields? uniquefields?
    COMMON_FIELDS =   %i(distance radio num_page country max_items min_price max_price min_size max_size order sort since_date pictures professional_video) # country? num_page? distance/radio?
    BEDROOM_FIELDS =  %i(no_smokers, gay_partners, no_pets_allowed, smoker, pets, sex, housemates)
    GARAGE_FIELDS =   %i(security automatic_door motorcycle_parking)
    HOME_FIELDS =     %i()
    # TODO turn into hash?

    def initialize(prop_type)
      if PROPERTY_TYPES.include?(prop_type)
        @type = prop_type
        @valid_fields = get_valid_optional_fields[prop_type] + get_valid_optional_fields[:common] + REQUIRED_FIELDS + LOCATION_FIELDS
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
      #unless attributes.all? { |e| @valid_fields.include? e}
        attributes.each do |e|
          unless @valid_fields.include? e
            raise ArgumentError, "Invalid query field: #{e}" 
          end
        end

    end

    private

      def get_valid_optional_fields
        # TODO get rid of this step. Make only one constant FIELDS 
        # which is a hash of symbols
        {
         common:  COMMON_FIELDS,
         bedrooms: BEDROOM_FIELDS,
         garages: GARAGE_FIELDS,
         homes:   HOME_FIELDS
        }
      end

  end
end
