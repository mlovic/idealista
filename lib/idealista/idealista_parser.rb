require 'idealista/error'

module Idealista
  class IdealistaParser

    def initialize(response)
      @response = response
    end

    def results
      return if error
      raise "Error parsing response body: #{response_body}" unless response_body['element_list']
      @results ||= response_body['element_list']
    end

    def error
      @error ||= get_error(response_body)
    end

    private

      def response_body
        @response_body ||= JSON.parse(@response.body).rubify_keys!
      rescue JSON::ParserError => e
        raise $!, "Error parsing response body (#{$!})\nResponse body:\n#{@response.body}\n", $!.backtrace
      end

      def get_error(body)
        return unless body['fault']
        code = error_code(body)
        if    code.include?('SpikeArrestViolation')
          return Error::SpikeArrestError.new(fault_string(body))
        elsif code.include?('QuotaViolation')
          return Error::QuotaViolation.new(fault_string(body))
        else
          return Error.new("Unknown error! #{body['fault']}")
        end
      end

    def error_code(body)
      body['fault'] && 
      body['fault']['detail'] && 
      body['fault']['detail']['errorcode']
    end

    def fault_string(body)
      body['fault'] && 
      body['fault']['fault_string']
    end
  end
end
