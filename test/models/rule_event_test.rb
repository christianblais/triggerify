require 'test_helper'

class RuleEventTest < ActiveSupport::TestCase
  test ".load" do
    attributes = {
      "timestamp" => "2022-02-26 18:33:03",
      "details" => [
        { "level" => "info", "message" => "Test message" },
      ]
    }
    event = RuleEvent.load(attributes)

    assert_equal(DateTime.parse("2022-02-26 18:33:03 UTC"), event.timestamp)
    assert_equal(:info, event.details.first.level)
    assert_equal("Test message", event.details.first.message)
  end

  test "#new" do
    travel_to("2022-02-26 18:33:03 UTC") do
      event = RuleEvent.new

      assert_equal([], event.details)
      assert_equal(DateTime.parse("2022-02-26 18:33:03 UTC"), event.timestamp)
    end
  end

  test "#add_detail" do
    event = RuleEvent.new
    event.add_detail(:info, "Test message 1")
    event.add_detail(:error, "Test message 2")

    assert_equal(:info, event.details[0].level)
    assert_equal("Test message 1", event.details[0].message)

    assert_equal(:error, event.details[1].level)
    assert_equal("Test message 2", event.details[1].message)
  end

  test "#dump" do
    travel_to("2022-02-26 18:33:03 UTC") do
      event = RuleEvent.new
      event.add_detail(:info, "Test message")
  
      expected = {
        "timestamp" => "2022-02-26 18:33:03",
        "details" => [
          { "level" => "info", "message" => "Test message" },
        ]
      }
      assert_equal(expected, event.dump)
    end
  end
end 
