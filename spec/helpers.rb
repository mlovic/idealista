require 'httparty'
require 'core_extensions/rubify_keys'
require 'idealista/query'
require 'idealista/property'

module Helpers
  Hash.include ::CoreExtensions::RubifyKeys

  class Client
    include HTTParty
    base_uri "http://idealista-prod.apigee.net/public/2/search"

    def get_raw_idealista_data(query)
      hash = self.class.get('', query: query)
    end

  end

  def sample_query(with_key: false, camel_case: false)
    # TODO best way to handle? create shortcut method?
    query = {:country => "es",
             :max_items => 5,
             :num_page => 1,
             :distance => 60,
             :center => "40.4229014,-3.6976351",
             :property_type => "bedrooms",
             :operation => "A",
             :order => "distance",
             :sort => "asc"
             }
     query.unrubify_keys! if camel_case
     query.merge!({"apikey" => Secret::API_KEY}) if with_key
     # TODO add merge method to Query?
     query.extend Idealista::Query
     return query
    # TODO unrubify?
  end

  def idealista_response
    # TODO clean up, refactor
    hash = {}
    VCR.use_cassette("sample") do
      client = Client.new
      #hash = client.get_raw_idealista_data(sample_query_with_key)
      hash = ::Helpers::Client.new.
        get_raw_idealista_data(sample_query(with_key: true, camel_case: true)).
        parsed_response
      hash.rubify_keys!
    end
    hash
  end

  def sample_property
    Idealista::Property.new(idealista_response["element_list"].first)
  end

  def test_search_method_with_missing_attribute(client, missing_attr)
    # missing_attr.to_s!
    VCR.use_cassette("request_missing_#{missing_attr.to_s}") do
      invalid_query = sample_query.remove_attr(missing_attr)
      expect { client.search(invalid_query) }.to raise_error(ArgumentError, 
                     "Required attributes: operation, property_type, and only one of [center, address, phone, user_code]")
    end
    # TODO put expectations in helper methods okay??
  end

end
