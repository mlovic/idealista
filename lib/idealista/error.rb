# TODO move to generic error file/module
module Idealista
  module Error

    class QuotaViolationError < StandardError
    end

    class SpikeArrestError < StandardError
    end
  end
end
