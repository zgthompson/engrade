require 'simplecov'
SimpleCov.start

#we need the actual library file
require_relative '../lib/engrade'
require_relative '../config/environment'
require 'rspec'
require 'factory_girl'
require 'webmock/rspec'
require 'vcr'

FactoryGirl.find_definitions

#RSpec config
RSpec.configure do |spec|
  spec.color_enabled = true
  spec.tty = true
  spec.include FactoryGirl::Syntax::Methods
end

#VCR config
VCR.configure do |c|
  c.default_cassette_options = { :serialize_with => :json, :preserve_exact_body_bytes => true }
  c.cassette_library_dir = 'spec/fixtures/engrade_cassettes'
  c.hook_into :webmock
end
