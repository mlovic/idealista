require 'idealista' 
#require_relative '../secret' # TODO fix this

RSpec.describe "simulating client" do
  it 'works' do
    VCR.use_cassette("sample") do
      query = sample_query(camel_case: false)
      client = Idealista::Client.new(Secret::API_KEY)
      properties = client.search(query)
      expect(properties.first).to be_a Idealista::Property #all?
      location = properties.first.location
    end
  end
end
