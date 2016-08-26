#$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '../'))
require "idealista/version"
require 'idealista/client'
require 'idealista/property'
require 'idealista/configuration'
require 'core_extensions/rubify_keys'

# TODO figure out best way to browse todos

module Idealista
  Hash.include CoreExtensions::RubifyKeys

  # Your code goes here...
end
