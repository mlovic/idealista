require_relative 'helpers'

RSpec.describe Helpers::Client, '#get_raw_idealista_data' do
  it 'returns a hash' do
    VCR.use_cassette("sample") do
      return_val = Helpers::Client.new.get_raw_idealista_data(sample_query_with_key)
      expect(return_val).to be_a Hash
    end
  end
end

RSpec.describe Helpers, '#sample_query' do
  it 'returns a hash' do
    expect(sample_query).to be_a Hash
  end
end

RSpec.describe Helpers, '#sample_query_with_key' do
  it 'returns hash with api key' do
    expect(sample_query_with_key).to have_key "apikey"
  end
end

RSpec.describe Helpers, '#idealista_response' do
  it 'does not raise an error' do
    expect { idealista_response }.not_to raise_error
  end
end
