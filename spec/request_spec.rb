require 'idealista/request'
require 'idealista/core_extensions/rubify_keys'

RSpec.describe Idealista::Request, "#new" do
  it "requires query and api key to build"
end

RSpec.describe Idealista::Request, "#perform" do
  let(:request) { Idealista::Request.new(sample_query, Secret::API_KEY) }
  let(:response) { VCR.use_cassette("standard") { request.perform } }

  it "returns response object" do
    expect(response).to be_a Net::HTTPOK
    expect(response.code).to eq "200"
  end

  it "response has body with correct string" do
    expect(response.body).to include "chueca"
  end

  it "handles redirects" do
    request = Idealista::Request.new({operation: "A", property_type: "bedrooms", center: "40.42,-3.69", distance: 100}, Secret::API_KEY)
    expect(Net::HTTP).to receive(:get_response).twice.and_call_original
    response = VCR.use_cassette("redirect") { request.perform } 
    expect(response.code).to eq '200'
  end
end
