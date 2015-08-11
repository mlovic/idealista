require 'idealista/query_validator'

module Idealista
  module Query

    def remove_attr(attr)
      #attr = attr.to_s if attr.is_a? Symbol
      self.delete(attr)
      self
    end

    def validate
      # GET PROP TYPE
      p self[:property_type]
      validator = QueryValidator.new(self[:property_type].to_sym) 
      # TODO singular or plural. convert?
      validator.validate(self)
      
      #unless [:property_type, :operation].all? { |e| self.keys.include? e} && 
             #([:center, :address, :phone, :user_code] & self.keys).size == 1
        #raise ArgumentError, 'Required attributes: operation, property_type, ' \
                             #'and only one of [center, address, phone, user_code]'
      #end
    end
  end
end
