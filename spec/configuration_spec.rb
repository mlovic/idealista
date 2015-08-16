require 'idealista/configuration'

RSpec.describe Idealista::Configuration do
  let(:config) { Idealista::Configuration.new }
  describe '#wait_and_retry' do

    it 'uses default values when no given a block' do
      config.wait_and_retry = true
      expect(config.sleep_time).to eq 3
      expect(config.number_of_retries).to eq 1
    end

    it 'accepts a block to set sleep time and number of retries' do
      config.wait_and_retry do |w|
        w.sleep_time = 2
        w.number_of_retries = 2
      end
      expect(config.sleep_time).to eq 2
      expect(config.number_of_retries).to eq 2
    end

    it 'uses default value when only sleep time is set' do
      #config.wait_and_retry do |w|
        #w.sleep_time = 2
      #end
      config.wait_and_retry do |w|
        w.sleep_time = 2
      end
      expect(config.sleep_time).to eq 2
      expect(config.number_of_retries).to eq 1
    end

  end
end
