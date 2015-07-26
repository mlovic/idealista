require 'idealista' 
#require_relative '../secret' # TODO fix this

RSpec.describe "simulating client" do
  it 'works' do
    #pending
    VCR.use_cassette("sample") do
      query = sample_query(camel_case: false)
      client = Idealista::Client.new(Secret::API_KEY)
      properties = client.search(query)
      expect(properties.first).to be_a Idealista::Property #all?
      #location = properties.first.location
      expect(properties.first.address).to eq 'de chueca 9'
    end
  end
end
