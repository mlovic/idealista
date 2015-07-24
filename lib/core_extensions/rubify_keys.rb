module CoreExtensions
  module RubifyKeys

    # Creates methods #rubify_keys! and #unrubify_keys!
    {"rubify" => "snake_case", "unrubify" => "camel_case"}.each do |name, kase|
      method_name = "#{name}_keys!"
      define_method(method_name) do 

        keys.each do |key|
          val = delete(key)
          new_key = self.send("convert_to_#{kase}", key.to_s)
          self[new_key] = val
          val.send(method_name) if val.is_a?(Hash)
          val.each { |p| p.send(method_name) if p.is_a?(Hash) } if val.is_a?(Array)
        end
        self

      end
    end

    private_class_method
      def convert_to_snake_case(string)
        string.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
               gsub(/([a-z\d])([A-Z])/,'\1_\2').
               tr("-", "_").
               downcase
      end

      def convert_to_camel_case(string)
        arr = string.split(/[_,-]/).inject([]) do |buffer,e| 
                buffer.push(buffer.empty? ? e : e.capitalize)
              end
        arr.join
      end
  end
end
