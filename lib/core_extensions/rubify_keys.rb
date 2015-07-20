module CoreExtensions
  module RubifyKeys

    # TODO metaprogram both definitions out of one to DRY up

    def rubify_keys! # TODO change to rubyify?
      keys.each{|k|
        v = delete(k)
        new_key = convert_to_snake_case(k.to_s)
        self[new_key] = v
        v.rubify_keys! if v.is_a?(Hash)
        v.each{|p| p.rubify_keys! if p.is_a?(Hash)} if v.is_a?(Array)
      }
      self
    end

    def unrubify_keys!
      keys.each{|k|
        v = delete(k)
        new_key = convert_to_camel_case(k.to_s)
        self[new_key] = v
        v.unrubify_keys! if v.is_a?(Hash)
        v.each{|p| p.unrubify_keys! if p.is_a?(Hash)} if v.is_a?(Array)
      }
      self
    end

    private_class_method
      def convert_to_snake_case(string)
        string.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
               gsub(/([a-z\d])([A-Z])/,'\1_\2').
               tr("-", "_").
               downcase
      end

      def convert_to_camel_case(string)
        string.split(/[_,-]/).inject([]){ |buffer,e| buffer.push(buffer.empty? ? e : e.capitalize) }.join
        # TODO style
      end
  end
end
