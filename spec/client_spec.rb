require_relative '../lib/idealista/client' # TODO fix load path
require_relative '../secret' # TODO fix this
require 'vcr'
require 'webmock'

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock # or :fakeweb
end

RSpec.describe Idealista::Client, ".new" do
  it 'returns client object' do
    client = Idealista::Client.new
    expect(client).to be_a Idealista::Client
  end
end

RSpec.describe Idealista::Client, "#search" do
  let(:query) { sample_query }
  let(:client) { Idealista::Client.new }
  it 'calls Idealista correctly' do
    VCR.use_cassette("sample") do
      properties = client.search(query)
      expect(properties).to have_key("elementList")
      expect(properties["elementList"].size).to eq 5
    end
  end
  it 'returns array of Properties' do
    pending
    #properties = client.search(query)
    expect(properties).to be_a Array
    expect(properties.first).to be_a Property #all?
  end
end

RSpec.describe Idealista::Client, "#configure" do
  it 'accepts configuration' do
    client = Idealista::Client.new
    configure_client = proc do 
      client.configure { |c| c.api_key = "secret123" }
    end
    expect(configure_client).not_to raise_error(StandardError)
  end
end

def sample_query
  query = {"apikey"   => Secret::API_KEY,
           "country" => "es",
           "maxItems" => 5,
           "numPage" => 1,
           "distance" => 60,
           "center" => "40.4229014,-3.6976351",
           "propertyType" => "bedrooms",
           "operation" => "A",
           "order" => "distance",
           "sort" => "asc"
  }
end
