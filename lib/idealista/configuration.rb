module Idealista
  class Configuration
    attr_accessor :sleep_time, :number_of_retries

    # TODO better place for defaults?
    # Default configuration values
    def initialize
      @sleep_time = nil
      @number_of_retries = nil
    end
    
    def wait_and_retry
      if block_given?
        self.wait_and_retry = true
        yield(self) 
      else
        !!(@sleep_time && @number_of_retries)
      end
    end

    def wait_and_retry=(bool)
      if bool
        @sleep_time = 3
        @number_of_retries = 1
      else
        @sleep_time = nil
        @number_of_retries = nil
      end
      #@sleep_time, @number_of_retries = val ? (3, 1) : (nil, nil)
    end

  end
end
