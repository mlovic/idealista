require 'idealista/query_validator'

module Idealista
  module Query

    def remove_attr(attr)
      #attr = attr.to_s if attr.is_a? Symbol
      self.delete(attr)
      self
    end

    def validate
      if self[:property_type]
        validator = QueryValidator.new(self[:property_type].to_sym) 
        # TODO singular or plural. convert?
        validator.validate(self)
      else
        raise ArgumentError, 'Required attribute: property_type'
      end
    end
  end
end
