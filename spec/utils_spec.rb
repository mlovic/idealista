require 'idealista/utils'

RSpec.describe Idealista::Utils, ".sleep_and_retry" do

  it 'waits and retries' do
    expect(Idealista::Utils).to receive(:sleep)
    expect {  
      Idealista::Utils.sleep_and_retry { raise StandardError, "test"}
    }.to raise_error(StandardError, "test") 
  end

  it 'sleeps for correct number of seconds' do
    expect(Idealista::Utils).to receive(:sleep).with(1.5)
    Idealista::Utils.sleep_and_retry(1.5) { raise StandardError, "test"} rescue StandardError
  end

  it 'retries correct number of times' do
    expect(Idealista::Utils).to receive(:sleep).twice
    Idealista::Utils.sleep_and_retry(1.5, 2) { raise StandardError, "test"} rescue StandardError
  end

  it 'rescues only the given exception class' do
    expect(Idealista::Utils).to_not receive(:sleep)
    expect {  
      Idealista::Utils.sleep_and_retry(nil, nil, ArgumentError) do
        raise StandardError, "test"
      end
    }.to raise_error(StandardError, "test") 
  end
end

