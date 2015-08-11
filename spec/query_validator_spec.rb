require 'idealista/query_validator'

RSpec.describe Idealista::QueryValidator, '.new' do
  it 'accepts valid property type as argument' do
    expect { Idealista::QueryValidator.new(:bedrooms) }.not_to raise_error
  end
  it 'does not accept invalid property type as argument' do
    expect { Idealista::QueryValidator.new(:beds) }.to raise_error(ArgumentError)
  end
end

RSpec.describe Idealista::QueryValidator, '#validate' do

  let(:query) { sample_query.extend Idealista::Query } 
    # TODO put extend in helper method
  let(:bedroom_validator) { Idealista::QueryValidator.new(:bedrooms) }
  # TODO how to dry up expectations

  it 'does not raise error for valid query' do
    expect { bedroom_validator.validate(query) }.not_to raise_error
  end

  it 'does not raise argument error for valid query' do
    query[:pictures] = true
    expect { bedroom_validator.validate(query) }.not_to raise_error
  end

  it 'does not raise argument error when address is used instead of center' do
    query.remove_attr(:center)
    query.remove_attr(:distance)
    query[:address] = '67 Center St'
  end

  it 'does raise argument error for missing required attribute' do
    query.remove_attr(:operation)
    expect { bedroom_validator.validate(query) }.to raise_error
  end

  it 'does raise argument error for wrong attribute' do
    query[:wrong_attribute] = 1
    expect { bedroom_validator.validate(query) }.to raise_error(ArgumentError, 
                         'Invalid query field: wrong_attribute') #with message?
  end

  it 'does raise argument error for attribute from wrong property type' do
    query[:security] = true 
    expect { bedroom_validator.validate(query) }.to raise_error
  end

  it 'does raise argument error for multiple location/identifier attributes' do
    query[:address] = '67 Center St'
    expect { bedroom_validator.validate(query) }.to raise_error(ArgumentError, 
                             'Required attributes: operation, property_type, ' \
                             'and only one of [center, address, phone, user_code]')
  end

  context 'when query is for garages' do
    let(:garage_validator) { Idealista::QueryValidator.new(:garages) }
    let :query do
      q = sample_query.extend(Idealista::Query)
      q[:property_type] = "garages"
      q
    end

    it 'does not raise argument error for valid query' do
      query[:security] = true
      expect { garage_validator.validate(query) }.not_to raise_error
    end

    it 'does raise argument error for attribute from wrong property type' do
      query[:smoker] = true 
      expect { garage_validator.validate(query) }.to raise_error
    end

  end

end
