require "net/http"
require 'idealista/core_extensions/rubify_keys'
require 'idealista/query'
require 'idealista/property'
require 'idealista/idealista_parser'
require 'idealista/request'

module Helpers
  Hash.include CoreExtensions::RubifyKeys

  def sample_query(with_key: false, camel_case: false)
    # TODO best way to handle? create shortcut method?
    # TODO put query into fixture ?
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
     query['apikey'] = Secret::API_KEY if with_key
     # TODO add merge method to Query?
     return query
    # TODO unrubify?
  end

    # TODO put query into fixture ?
  def idealista_response(spike_arrest: false, quota_violation: false)
    cassette = spike_arrest ? 'spike_arrest_violation' : 'standard'
    cassette = quota_violation ? 'quota_violation' : 'standard'
    uri      = "http://idealista-prod.apigee.net/public/2/search"
    query    = sample_query(with_key: true, camel_case: true)
    VCR.use_cassette(cassette) do
      Idealista::Request.new(sample_query, Secret::API_KEY).perform
    end
  end

  def sample_property
    # TODO fix this. fixture at least
    Idealista::Property.new(Idealista::IdealistaParser.new(idealista_response).results.first)
  end

  def test_search_method_with_missing_attribute(client, missing_attr)
    # missing_attr.to_s!
    VCR.use_cassette("request_missing_#{missing_attr.to_s}") do
      # TODO maybe fix this?
      invalid_query = sample_query.extend(Idealista::Query).remove_attr(missing_attr)
      expect { client.search(invalid_query) }.to raise_error(ArgumentError)
                     #"Required attributes: operation, property_type, and only one of [center, address, phone, user_code]")
    end
    # TODO put expectations in helper methods okay??
  end

  def execute_search_with_spike_arrest(client)
    VCR.use_cassette("spike_arrest_violation", allow_playback_repeats: true) { client.search(sample_query) }
  #rescue 
    #nil
  # TODO fix the rescue nil
  end

  #def set_wait_and_retry(client, time, retries)
    #client.configure do |c| 
      #c.wait_and_retry do |w| # somehow get rid of w?
        #w.wait_time = time
        #w.number_of_retries = retries
      #end
    #end
    #client
  #end
end
