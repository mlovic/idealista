module Idealista
  class Error < StandardError

    class QuotaViolation < self
    end

    class SpikeArrestError < self
    end
  end
end
