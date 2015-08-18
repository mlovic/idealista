require 'idealista' 
#require_relative '../secret' # TODO fix this

RSpec.describe "simulating client", :vcr do
  it 'works' do
    # TODO change sample to standard
    # TODO set standard as default in the spec helper somehow?
    VCR.use_cassette("standard") do
      query = sample_query(camel_case: false)
      client = Idealista::Client.new(Secret::API_KEY)
      client.configure { |c| c.wait_and_retry = true }
      properties = client.search(query)
      expect(properties.first).to be_a Idealista::Property #all?
      #location = properties.first.location
      expect(properties.first.address).to eq 'de chueca 9'
    end
  end
end
