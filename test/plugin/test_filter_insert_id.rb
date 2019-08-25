require "helper"
require "fluent/plugin/filter_insert_id.rb"

class InsertIdFilterTest < Test::Unit::TestCase
  setup do
    Fluent::Test.setup
  end

  test "failure" do
    flunk
  end

  private

  def create_driver(conf)
    Fluent::Test::Driver::Filter.new(Fluent::Plugin::InsertIdFilter).configure(conf)
  end
end
