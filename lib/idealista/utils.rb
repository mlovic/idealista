module Idealista
  module Utils

    def self.sleep_and_retry(sleep_time  = nil, 
                             max_retries = nil, 
                             error_class = StandardError) 
      # TODO allow list of errors
      max_retries ||= 1
      tries       ||= 0
      yield
    rescue error_class
      if tries < max_retries
        tries += 1
        sleep sleep_time || 2
        retry
      else
        raise
      end
    end
  end
end
