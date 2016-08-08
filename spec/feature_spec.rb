require 'idealista' 
#require_relative '../secret' # TODO fix this

RSpec.describe "simulating client", :vcr do
  it 'user retrieves list of property coordinates' do
    # TODO set standard as default in the spec helper somehow?
    VCR.use_cassette("standard") do
      query = sample_query(camel_case: false)
      client = Idealista::Client.new(Secret::API_KEY)
      client.configure { |c| c.wait_and_retry = true }
      properties = client.search(query)

      expect(properties.first).to be_a Idealista::Property
      expect(properties.first.address).to eq 'plaza chueca, 33'

      property_coordinates = properties.map(&:coordinates)

      expect(property_coordinates.first).to eq [40.422726, -3.6976103]
    end
  end
end
