require 'core_extensions/rubify_keys'
require "net/http"
require 'json'

module Idealista
  class Request
    BASE_URL = "http://idealista-prod.apigee.net/public/2/search"

    def initialize(query, key)
      @query = query.dup.merge(apikey: key).unrubify_keys!
    end

    def perform
      uri = URI.parse(BASE_URL)
      uri.query = URI.encode_www_form(@query)
      response = Net::HTTP.get_response(uri)
      #data = JSON.parse(response.body).rubify_keys
    end
  end

end
