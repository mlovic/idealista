#$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '../'))

require 'httparty'
require 'idealista/configuration'
#require 'idealista/core_extensions/rubify_keys'


module Idealista
  # TODO implement search method as part of idealista module? In addition to 
  # client class, like twitter
  class Client

    include HTTParty
    Hash.include ::CoreExtensions::RubifyKeys
    base_uri "http://idealista-prod.apigee.net/public/2/search"

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
      failed_once ||= false # TODO fix this 
      #validate_args(query)
      query.validate
      query.unrubify_keys!
      query[:apikey] = @key
      hash = self.class.get('', query: query).parsed_response
      # TODO separate call and dealing with response
      raise StandardError, 'Unexpected idealista response!' unless hash.is_a? Hash
      hash.rubify_keys!
      if hash["fault"] && 
         hash["fault"]["faultstring"].include?('Spike arrest violation')
        # TODO use errorcode instead?
        raise SpikeArrestError, hash["fault"]["faultstring"]
      end
      # TODO deal with different http response body encodings. httparty parses 
      # binary into a hash, not string
      # Seems to work actully, with spike arrest at least
      properties = Property.parse(hash["element_list"])
    rescue SpikeArrestError 
      if @configuration.wait_and_retry && !failed_once
        failed_once = true
        sleep 3
        retry
      else
        raise
      end
    end
      # TODO convert response to symbols?

  end
end
