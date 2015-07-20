$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '../'))

require 'httparty'
#require 'idealista/core_extensions/rubify_keys'


module Idealista
  #TODO use client class or just use Idealista mod ?
  class Client

    include HTTParty
    base_uri "http://idealista-prod.apigee.net/public/2/search"
    #base_uri "http://idealista.com"

    def initialize(key = nil)
      raise ArgumentError unless key.is_a? String
      @key = key
    rescue ArgumentError
      raise $!, 'Client must be initialized with Idealista api key as sole argument'
      #shortcut okay?
    end

    def search(query)
      validate_args(query)
      query.unrubify_keys!
      # TODO convert to symbols?
      Hash.include ::CoreExtensions::RubifyKeys
      query["apikey"] = @key
      hash = self.class.get('', query: query).parsed_response
      # TODO wtf is up with httparty.get??
      raise StandardError, 'Unexpected idealista response!' unless hash.is_a? Hash
      hash.rubify_keys!
      properties = Property.parse(hash["element_list"])
      #self.class.get('', query: query)
    end

    private

      def validate_args(args)
        # TODO extract into validator class/module??
        # TODO best way? does include? accept hash?
        unless ["property_type", "operation"].all? { |e| args.keys.include? e} && 
               (['center', 'address', 'phone', 'user_code'] & args.keys).size == 1
          raise ArgumentError, 'Required attributes: operation, property_type, and only one of [center, address, phone, user_code]'
        end
      end

  # TODO make spikearresterror inherit from networkError or similar

  end
end
