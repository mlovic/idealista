# Given that it is always loaded, you are encouraged to keep this file as
# light-weight as possible. Requiring heavyweight dependencies from this file
# will add to the boot time of your test suite on EVERY test run, even for an
# individual file that may not need all of that loaded. Instead, consider making
# a separate helper file that requires the additional dependencies and performs
# the additional setup, and require it from the spec files that actually need
# it.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration


require 'vcr'
require 'webmock'
require_relative 'helpers'
require_relative '../secret' # TODO fix this

RSpec.configure do |config|

    config.include Helpers

  config.color = true #TODO why .rspec not detected?
  config.expect_with :rspec do |expectations|
  config.disable_monkey_patching!
  #config.profile_examples = 5

    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|

    mocks.verify_partial_doubles = true
  end

end

# TODO lazt connfigure, or put only in spec files?

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock # or :fakeweb
end

