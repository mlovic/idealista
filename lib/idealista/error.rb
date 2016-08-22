# TODO move to generic error file/module
module Idealista
  class Error < StandardError

    class QuotaViolation < self
    end

    class SpikeArrestError < self
    end
  end
end
