require 'idealista/query' 

RSpec.describe Idealista::Query, '#remove_attr' do
  let(:query) { {"one" => 1, "two" => 2}.extend Idealista::Query }

  it 'removes key successfully' do
    query.remove_attr("one")
    expect(query).not_to have_key("one")
  end

  it 'allows symbol as parameter' do
    query.remove_attr(:one)
    expect(query).not_to have_key("one")
  end

end
