#$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '../'))
require "net/http"
require 'json'

require 'idealista/configuration'
require 'idealista/idealista_parser'
require 'core_extensions/rubify_keys'
require 'idealista/query'
require 'idealista/error'


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
      query.validate
      query.unrubify_keys!
      query[:apikey] = @key
      sleep_and_retry(@configuration.sleep_time, @configuration.number_of_retries) do
        uri = URI.parse(BASE_URL)
        uri.query = URI.encode_www_form(query)
        response = Net::HTTP.get_response(uri)
        data = JSON.parse(response.body)

        properties = IdealistaParser.parse(data)
      end
      #properties
      # TODO separate call and dealing with response. Request.perform?
      # TODO deal with different http response body encodings. httparty parses 
      # binary into a hash, not string
      # Seems to work actually, with spike arrest at least
      # TODO convert response to symbols?
    end

    private

      def sleep_and_retry(sleep_time, max_retries)
        tries ||= 0
        yield
        # TODO extract SAE?
      rescue SpikeArrestError 
        puts 'rescuing sa error'
        if @configuration.wait_and_retry && tries < max_retries
          tries += 1
          sleep sleep_time
          retry
        else
          raise
          puts 'error not allowed'
        end
      end

  end
end
