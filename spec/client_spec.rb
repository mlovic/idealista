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
    VCR.use_cassette("standard") do
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

  context 'when quota violation occurs' do
    it 'raises quota violation error' do
      VCR.use_cassette("quota_violation") do
        expect { client.search(sample_query) }.to raise_error(QuotaViolationError)
        # TODO Write method to catch spike arrest response?
      end
    end
    # TODO research how to set same examples for different contexts
    
  end
  context 'when spike arrest occurs' do
    pending

    it 'raises spike arrest error' do
      VCR.use_cassette("spike_arrest_violation") do
        expect { client.search(sample_query) }.to raise_error(SpikeArrestError, 
                            "Spike arrest violation. Allowed rate : 1ps")
        # TODO Write method to catch spike arrest response?
      end
    end
    # TODO research how to set same examples for different contexts
    
    context 'when sleep and retry is set' do

      it 'waits and retries' do
        pending
        client.configure { |c| c.wait_and_retry = true } # okay?
        expect(client).to receive(:sleep)
        expect { execute_search_with_spike_arrest(client) }.to raise_error SpikeArrestError
        #execute_search_with_spike_arrest(client) rescue nil
      end

      context 'when sleep_time and number_of_retries are set individually' do
        #not necessary ?

        before do
          @client = Idealista::Client.new(Secret::API_KEY)
          @client.configure do |c| 
            c.wait_and_retry do |w| # somehow get rid of w?
              w.sleep_time = 2
              w.number_of_retries = 2
            end
          end
        end

        it 'client sleeps for correct number of seconds' do
          pending
          expect(@client).to receive(:sleep).with(2).twice
          expect { execute_search_with_spike_arrest(@client) }.to raise_error SpikeArrestError
        end

        it 'client retries correct number of times' do
          pending
          expect(@client).to receive(:sleep).twice
          expect { execute_search_with_spike_arrest(@client) }.to raise_error SpikeArrestError
        end
      end

    end

    context 'when sleep_and_retry is not set' do
      it 'does not waits and retries' do
        pending
        expect(client).not_to receive(:sleep)
        #execute_search_with_spike_arrest(client, only_first_time: true) 
        expect {execute_search_with_spike_arrest(client)}.to raise_error
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

