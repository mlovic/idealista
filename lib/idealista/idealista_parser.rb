module Idealista
  class IdealistaParser

    def self.parse(response)
      raise StandardError, 'response is not a hash!' unless response.is_a? Hash
      response.rubify_keys! 
      if response.has_key? "element_list"
        # TODO strings to symbols?
        response['element_list'].map do |p|
          raise "Element is not a hash: #{p.inspect}" unless p.is_a? Hash
          Property.new(p)
        end
      elsif response["fault"] && 
            response["fault"]["faultstring"].include?('Spike arrest violation')
        # TODO use errorcode instead?
        raise SpikeArrestError, response["fault"]["faultstring"]
      else
        raise 'Unexpected response!'
      end
    end

  end
end
