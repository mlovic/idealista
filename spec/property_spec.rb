require_relative 'helpers'
require 'idealista/property' 
require 'vcr'
require 'webmock'

RSpec.configure do |c|
  c.include Helpers
end
# TODO clean up unnecessary dependency declaration

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

RSpec.describe Idealista::Property, '#coordinates' do
  let(:property) { sample_property }

  it 'returns an array of two numbers' do    
    expect(property.coordinates).to be_an Array
    expect(property.coordinates.size).to eq 2
    expect(property.coordinates.first).to be_a Float
  end
end
