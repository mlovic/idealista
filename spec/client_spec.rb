require_relative '../lib/idealista/client' # TODO fix load path. Add lib in
require_relative '../lib/idealista/property' 
require_relative '../lib/core_extensions/rubify_keys' 
# TODO require ony necessary files or all lib/idelista.rb?

RSpec.describe Idealista::Client, ".new" do
  context 'when passed a string' do
    it 'returns a client object' do
      client = Idealista::Client.new('secret01')
      expect(client).to be_a Idealista::Client
    end
    it 'does not raise argument error' do
      expect { Idealista::Client.new('secret01') }.not_to raise_error(ArgumentError)
    end
  end
  
  context 'when not passed a string as argument' do
    it 'raises argument error with message' do
      expect { Idealista::Client.new }.to raise_error(ArgumentError, 
            'Client must be initialized with Idealista api key as sole argument')
      expect { Idealista::Client.new(4) }.to raise_error(ArgumentError, 
            'Client must be initialized with Idealista api key as sole argument')
    end
  end
end

RSpec.describe Idealista::Client, "#search" do
  let(:query) { sample_query }
  let(:client) { Idealista::Client.new(Secret::API_KEY) }

  #it 'calls Idealista correctly' do
    #pending
    #VCR.use_cassette("sample") do
      #properties = client.search(sample_query)
      #expect(properties).to have_key("element_list")
      #expect(properties["element_list"].size).to eq 5
    #end
  #end

  it 'returns array of Properties' do
    VCR.use_cassette("sample") do
      properties = client.search(sample_query)
      expect(properties).to be_a Array
      expect(properties.first).to be_a Idealista::Property #all?
    end
  end

  context 'arguments are invalid' do
    before(:each) { @invalid_query = sample_query }
    # TODO write helper method to dry up
    
    it 'raises argument error without property_type' do
      test_search_method_with_missing_attribute(client, :property_type)
    end
    it 'raises argument error without operation' do
      test_search_method_with_missing_attribute(client, :operation)
    end
    it 'raises argument error without location attribute' do
      test_search_method_with_missing_attribute(client, :center)
    end
    it 'raises error when more than one location attribute is passed'
    # TODO not sure best way
  end
end

RSpec.describe Idealista::Client, "#configure" do
  it 'accepts configuration' do
    pending
    client = Idealista::Client.new
    configure_client = proc do 
      client.configure { |c| c.api_key = "secret123" }
    end
    expect(configure_client).not_to raise_error(StandardError)
  end
end

