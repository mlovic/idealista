require 'idealista/query' 

RSpec.describe Idealista::Query, '#remove_attr' do
  let(:query) { {one: 1, two: 2}.extend Idealista::Query }

  it 'removes key successfully' do
    query.remove_attr(:one)
    expect(query).not_to have_key(:one)
  end

  it 'allows symbol as parameter' do
    query.remove_attr(:one)
    expect(query).not_to have_key(:one)
  end

end

RSpec.describe Idealista::Query, '#validate' do
  # TODO pass property type as arg instead of reading internally from query hash?
  # TODO extract to query validator class?
  #context 'query is for bedrooms' do
  #end
  context 'when wrong attribute applies to all property types' do
    let(:query) { sample_query.extend Idealista::Query }

    it 'does not raise argument error for valid query' do
      query[:pictures] = true
      expect { query.validate }.not_to raise_error
    end

    it 'does raise argument error for missing required attribute' do
      query.remove_attr(:operation)
      expect { query.validate }.to raise_error
    end

    it 'does raise argument error for wrong attribute' do
      query[:wrong_attribute] = 1
      expect { query.validate }.to raise_error(ArgumentError) #with message?
    end
  end
  context 'when wrong attribute applies to single property type' do
    it 'reads property type from query attr hash correctly'
  end
end
