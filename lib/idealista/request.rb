require 'idealista/core_extensions/rubify_keys'
require "net/http"
require 'json'

module Idealista
  class Request
    BASE_URL = "http://idealista-prod.apigee.net/public/2/search"

    def initialize(query, key)
      @query = query.dup.merge(apikey: key).unrubify_keys!
    end

    def perform
      request_with_redirects(BASE_URL, @query)
    end
     
    private

      def request_with_redirects(base, query)
        uri = build_uri(base, query)
        #puts "Fetching #{uri}"
        response = Net::HTTP.get_response(uri)
        if (response.code == "301" or response.code == "302")
          #puts "Redirecting to ... #{response.header['location']}"
          request_with_redirects(response.header['location'], query)
        else
          response
        end
      end

      def build_uri(base, query)
        uri = URI.parse(base)
        uri.query = URI.encode_www_form(query)
        uri
      end
  end
end
