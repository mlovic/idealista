require 'idealista/idealista_parser'

RSpec.describe Idealista::IdealistaParser, '#results' do
  context 'when response is standard' do
    let(:response) { Idealista::IdealistaParser.new(idealista_response) }

    it 'returns enumerable of results' do
      expect(response.results).to be_a Enumerable
    end

    it 'each result is a hash of property attributes' do
      expect(response.results.first['address']).to eq "plaza chueca, 33"
    end
  end

  context 'when response contains error' do
    let(:response) { Idealista::IdealistaParser.new(idealista_response(quota_violation: true)) }
    it 'returns nil' do
      expect(response.results).to eq nil
    end
  end
end

RSpec.describe Idealista::IdealistaParser, '#error' do
  context 'when response is standard' do
    let(:response) { Idealista::IdealistaParser.new(idealista_response) }

    it 'returns enumerable of results' do
      expect(response.error).to eq nil 
    end
  end

  context 'when response contains error' do
    let(:response) { Idealista::IdealistaParser.new(idealista_response(quota_violation: true)) }
    it 'returns instance of error' do
      expect(response.error).to be_a Idealista::Error::QuotaViolation
    end
  end
end

#RSpec.describe Idealista::IdealistaParser, '.parse' do
  #pending

  #context 'when response is standard' do
    #let(:response) { idealista_response }

    #it 'returns an array of properties' do
      #pending
      #properties = Idealista::IdealistaParser.parse(response)
      #expect(properties).to be_an Array
      #expect(properties.first).to be_a Idealista::Property 
    #end
  #end

  #context 'when response is spike arrest error' do
    #let(:response) { idealista_response(spike_arrest: true) }

    #it 'raises spike arrest error' do
      #pending
      #expect { Idealista::IdealistaParser.parse(response) }.to raise_error
    #end
  #end

  #context 'when response is spike arrest error' do
    #let(:response) { idealista_response(spike_arrest: true) }

    #it 'raises spike arrest error' do
      #pending
      #expect { Idealista::IdealistaParser.parse(response) }.to raise_error
    #end
  #end

#end
