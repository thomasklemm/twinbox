ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Add helper methods to be used by all tests here...

  # TODO: Right here?
  Fabrication.clear_definitions
end