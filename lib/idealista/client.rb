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
      query.unrubify_keys!
      #validate_args(query)
      Hash.include ::CoreExtensions::RubifyKeys
      query["apikey"] = @key
      hash = self.class.get('', query: query)
      hash.rubify_keys!
      properties = Property.parse(hash["element_list"])
      #self.class.get('', query: query)
    end

    private

      def validate_args(args)
      end

  end
end
