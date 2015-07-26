require_relative 'helpers'
require 'idealista/client' 

RSpec.describe Helpers::Client, '#get_raw_idealista_data' do
  it 'returns a hash' do
    VCR.use_cassette("sample") do
      return_val = Helpers::Client.new
                             .get_raw_idealista_data(sample_query(with_key: true,
                                                                  camel_case: true))
      expect(return_val).to be_a Hash
    end
  end
end

RSpec.describe Helpers, '#sample_query' do
  it 'returns a hash' do
    expect(sample_query).to be_a Hash
  end
  it 'adds key when called with key' do
    expect(sample_query(with_key: true)).to have_key "apikey"
  end
  it 'converts to camel_case when called with camel_case option' do
    expect(sample_query(camel_case: true)).to have_key "propertyType"
  end
  it 'raises argument error when called with other option' do
    expect { sample_query(wrong_option: true) }.to raise_error(ArgumentError)
  end
  it 'return hash extends Query' do
    expect(sample_query).to respond_to :remove_attr
  end
end

#RSpec.describe Helpers, '#sample_query_with_key' do
  #it 'returns hash with api key' do
    #expect(sample_query_with_key).to have_key "apikey"
  #end
#end

RSpec.describe Helpers, '#idealista_response' do
  it 'does not raise an error' do
    expect { idealista_response }.not_to raise_error
  end
  it 'returns hash' do
    expect(idealista_response).to be_a Hash
  end
end

RSpec.describe Helpers, '#sample_property' do
  it 'returns a Property' do
    expect(sample_property).to be_a Idealista::Property
    # TODO always explicitly refer to classes with all toplevel modules? check twitt
  end

  it 'property has all getter methods' do
    require 'pp'
    pp idealista_response
    expect(sample_property).to respond_to :address
    expect(sample_property).to respond_to :bathrooms
  end
end

# Not going to test this
#
#RSpec.describe Helpers, '#test_search_method_with_missing_attribute' do
  #let(:client) { client = Idealista::Client.new(Secret::API_KEY) }

  #it 'does not raise argument error when passed a single symbol' do
    #expect { test_search_method_with_missing_attribute(client, :attr) }.not_to raise_error(ArgumentError)
  #end

  #it 'calls Client#search' do
    #expect(client).to receive(:search)
    #test_search_method_with_missing_attribute(client, :attr)
  #end
  #it 'calls Client#search with a missing attribute'
#end
