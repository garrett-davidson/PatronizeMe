require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def assert_collection_sorted_asc(collection, symbol)
    value = collection[0]
    collection.each do |element|
      next_value = element.send(symbol)
      assert value <= next_value
      value = next_value
    end
  end

  def assert_collection_sorted_desc(collection, symbol)
    value = collection[0].send symbol
    collection.each do |element|
      next_value = element.send(symbol)
      assert value >= next_value
      value = next_value
    end
  end
end
