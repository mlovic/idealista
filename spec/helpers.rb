require 'httparty'
require_relative '../lib/core_extensions/rubify_keys'

module Helpers
  Hash.include ::CoreExtensions::RubifyKeys

  class Client
    include HTTParty
    base_uri "http://idealista-prod.apigee.net/public/2/search"

    def get_raw_idealista_data(query)
      hash = self.class.get('', query: query)
    end

  end

  def sample_query
    {"country" => "es",
     "maxItems" => 5,
     "numPage" => 1,
     "distance" => 60,
     "center" => "40.4229014,-3.6976351",
     "propertyType" => "bedrooms",
     "operation" => "A",
     "order" => "distance",
     "sort" => "asc"
    }
    # TODO unrubify?
  end

  def sample_query_with_key
    sample_query.merge({"apikey" => Secret::API_KEY})
  end

  def idealista_response
    VCR.use_cassette("sample") do
      client = Client.new
      #hash = client.get_raw_idealista_data(sample_query_with_key)
      hash = ::Helpers::Client.new.get_raw_idealista_data(sample_query_with_key).parsed_response
      hash.rubify_keys!
    end
  end

end
