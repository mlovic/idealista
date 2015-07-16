require 'httparty'

module Idealista
  #TODO use client class or just use Idealista mod ?
  class Client

    include HTTParty
    base_uri "http://idealista-prod.apigee.net/public/2/search"
    #base_uri "http://idealista.com"

    def initialize
    end

    def search(query)
      properties = self.class.get('', query: query)
      #self.class.get('', query: query)
    end

    def configure

    end

  end
end
