require_relative 'helpers'
require 'idealista/property' 
require 'vcr'
require 'webmock'

RSpec.configure do |c|
  c.include Helpers
end

RSpec.describe Idealista::Property, '.new' do
  it 'accepts hash of options' do
    attributes = {"address" => "one", "property_type" => "two"}
    expect { Idealista::Property.new(attributes) }.not_to raise_error(ArgumentError)
  end
end

RSpec.describe Idealista::Property, '.parse' do
  it 'returns array of properties' do
    element_list = idealista_response["element_list"]
    properties = Idealista::Property.parse(idealista_response)
  end
end
