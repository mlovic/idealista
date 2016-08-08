require 'idealista/error'

module Idealista
  class IdealistaParser

    def self.parse(response)
      raise StandardError, 'response is not a hash!' unless response.is_a? Hash
      response.rubify_keys! 
      # TODO check code first
      if response.has_key? "element_list"
        # TODO strings to symbols?
        response['element_list'].map do |p|
          raise "Element is not a hash: #{p.inspect}" unless p.is_a? Hash
          Property.new(p)
        end
      elsif response["fault"] && 
            response["fault"]["faultstring"].include?('Spike arrest violation')
        # TODO add quotaviolation here
        # TODO use errorcode instead?
        raise SpikeArrestError, response["fault"]["faultstring"]
      elsif response["fault"] && 
            response["fault"]["detail"]["errorcode"].include?('QuotaViolation')
        raise QuotaViolationError, response["fault"]["faultstring"]
      else
        raise "Unexpected response!:  #{response}"
      end
    end

  end
end
