require_relative '../lib/idealista' 
#require_relative '../secret' # TODO fix this

RSpec.describe "simulating client" do
  it 'works' do
    pending
    query = Hash.new
    #create sample hash?
    properties = Idealista::Client.new.search(query)
    expect(properties).to be_a Array
    expect(properties.first).to be_a Property #all?
  end
end
