require 'idealista/client'
require 'idealista/property'
require 'idealista/spike_arrest_error'
require 'core_extensions/rubify_keys'
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

RSpec.describe Idealista::Client, '.configure' do
  let(:client) { Idealista::Client.new(Secret::API_KEY) }
  it 'accepts block' do
    expect { client.configure { |c| c.wait_and_retry = true } }.not_to raise_error
  end
  it 'changes client instance configuration' do
    expect(client.configuration.wait_and_retry).to be false
    client.configure { |c| c.wait_and_retry = true } 
    expect(client.configuration.wait_and_retry).to be true
  end
end

RSpec.describe Idealista::Client, "#search" do
  let(:query) { sample_query }
  let(:client) { Idealista::Client.new(Secret::API_KEY) }

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

  context 'when spike arrest occurs' do
    it 'raises spike arrest error' do
      VCR.use_cassette("spike_arrest_violation") do
        expect { client.search(sample_query) }.to raise_error(SpikeArrestError, 
                            "Spike arrest violation. Allowed rate : 1ps")
        # TODO Write method to catch spike arrest response?
      end
    end
    context 'when sleep and retry is set' do
      it 'waits and retries' do
        client.configure { |c| c.wait_and_retry = true } # okay?
        expect(client).to receive(:sleep)
        execute_search_with_spike_arrest(client)
      end
    end
    context 'when sleep and retry is not set' do
      it 'does not waits and retries' do
        expect(client).not_to receive(:sleep)
        execute_search_with_spike_arrest(client)
      end
    end
  end
end

RSpec.describe Idealista::Client, "#search_bedrooms" do
  it 'works without bedroom attribute in input query'
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

