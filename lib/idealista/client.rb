require "net/http"
require 'json'

require 'idealista/configuration'
require 'idealista/idealista_parser'
require 'idealista/core_extensions/rubify_keys'
require 'idealista/query'
require 'idealista/error'
require 'idealista/utils'

module Idealista
  class Client

    Hash.include CoreExtensions::RubifyKeys
    BASE_URL = "http://idealista-prod.apigee.net/public/2/search"

    attr_accessor :configuration

    def initialize(key = nil)
      raise ArgumentError unless key.is_a? String
      @key = key
      @configuration = Configuration.new
    rescue ArgumentError
      raise $!, 'Client must be initialized with Idealista api key as sole argument'
    end

    def configure
      yield(configuration)
    end

    def search(query)
      query = query.dup
      query.extend Idealista::Query
      query.validate # TODO add bang
      request = Request.new(query, @key) # TODO search/action specific name?
      if @configuration.wait_and_retry
        Idealista::Utils.sleep_and_retry(@configuration.sleep_time, 
                                         @configuration.number_of_retries, 
                                         Idealista::Error) do
          raw_response = request.perform
        end
      else
          raw_response = request.perform
      end
      response = IdealistaParser.new(raw_response)
      raise response.error if response.error
      response.results.map { |result| Property.new(result) }
    end
  end
end
