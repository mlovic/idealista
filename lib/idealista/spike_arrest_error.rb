# TODO move to generic error file/module
class QuotaViolationError < StandardError
end

class SpikeArrestError < StandardError
  #def initialize
    #super
  #end

  #def message
    #'Spike arrest violation custom message'
  #end
end
