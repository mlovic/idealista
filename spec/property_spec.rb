require_relative 'helpers'
require 'idealista/property' 
require 'vcr'
require 'webmock'

RSpec.configure do |c|
  c.include Helpers
end

RSpec.describe Idealista::Property, '.new' do
  # TODO extract setup to fixtures
  let(:attributes) do
    # TODO take attributes from vcr cassette. write helper method to parse cassete?
    attributes = {"address" => "one", "bedrooms" => 3,  "property_type" => "two"}
  end
  let(:property) { Idealista::Property.new(attributes) }

  it 'accepts hash of attributes' do
    expect { Idealista::Property.new(attributes) }.not_to raise_error
                                                          #(ArgumentError)
  end

  it 'creates getter method for each attribute' do
    expect(property).to respond_to :address
    expect(property).to respond_to :bedrooms
    #expect(property).to respond_to :property_type TODO
  end

end

RSpec.describe Idealista::Property, '.parse' do
  it 'returns array of properties' do
    element_list = idealista_response["element_list"]
    properties = Idealista::Property.parse(element_list)
  end
end

RSpec.describe Idealista::Property, '#location' do
  let(:property) { sample_property }

  it 'returns an array of two numbers' do    
    expect(property.location).to be_an Array
    expect(property.location.size).to eq 2
    expect(property.location.first).to be_a Float
  end
end
