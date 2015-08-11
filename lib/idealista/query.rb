require 'idealista/query_validator'

module Idealista
  module Query

    def remove_attr(attr)
      #attr = attr.to_s if attr.is_a? Symbol
      self.delete(attr)
      self
    end

    def validate
      validator = QueryValidator.new(self[:property_type].to_sym) 
      # TODO singular or plural. convert?
      validator.validate(self)
    end
  end
end
