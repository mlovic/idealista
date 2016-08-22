#$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '../'))
require "net/http"
require 'json'

require 'idealista/configuration'
require 'idealista/idealista_parser'
require 'core_extensions/rubify_keys'
require 'idealista/query'
require 'idealista/error'
require 'idealista/utils'


class SpikeArrestError < StandardError
end

module Idealista
  # TODO implement search method as part of idealista module? In addition to 
  # client class, like twitter
  class Client

    Hash.include ::CoreExtensions::RubifyKeys
    BASE_URL = "http://idealista-prod.apigee.net/public/2/search"

    attr_accessor :configuration

    def initialize(key = nil)
      raise ArgumentError unless key.is_a? String
      @key = key
      @configuration = ::Idealista::Configuration.new
    rescue ArgumentError
      raise $!, 'Client must be initialized with Idealista api key as sole argument'
      #shortcut okay?
    end

    def configure
      # TODO replace with @configuration? or better alternative?
      yield(configuration)
    end

    def search(query)
      # TODO maybe return results object instead, containing @properties and response body and info. Including enumerable
      # TODO clean this up, write spec
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
      # TODO separate call and dealing with response. Request.perform?
      # TODO deal with different http response body encodings. httparty parses 
      # Seems to work actually, with spike arrest at least
      # TODO convert response to symbols?
    end
  end
end
