guard :rspec, cmd: 'rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/idealista/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib/core_extensions/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
  watch('spec/helpers.rb')  { |m| 'spec/helpers_spec.rb' }
end
