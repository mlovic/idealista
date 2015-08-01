module Idealista
  class Configuration
    attr_accessor :wait_and_retry

    # TODO better place for defaults?
    # Default configuration values
    def initialize
      @wait_and_retry = false
    end
  end
end
