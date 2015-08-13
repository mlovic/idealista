require 'idealista/idealista_parser'

RSpec.describe Idealista::IdealistaParser, '.parse' do

  context 'when response is standard' do
    let(:response) { idealista_response }

    it 'returns an array of properties' do
      properties = Idealista::IdealistaParser.parse(response)
      expect(properties).to be_an Array
      expect(properties.first).to be_a Idealista::Property 
    end
  end

  context 'when response is spike arrest error' do
    let(:response) { idealista_response(spike_arrest: true) }

    it 'raises spike arrest error' do
      expect { Idealista::IdealistaParser.parse(response) }.to raise_error
    end

  end

end
