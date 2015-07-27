module Idealista
  module Query

    def remove_attr(attr)
      #attr = attr.to_s if attr.is_a? Symbol
      self.delete(attr)
      self
    end

  end
end
