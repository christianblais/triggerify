require 'test_helper'

class RuleEventTest < ActiveSupport::TestCase
  test ".load" do
    attributes = {
      "shopify_identifier" => "abc",
      "hooklys_identifier" => "def",
      "details" => [
        { "timestamp" => "2022-02-26 18:33:03", "level" => "info", "message" => "Test message" },
      ]
    }
    event = RuleEvent.load(attributes)

    assert_equal("abc", event.shopify_identifier)
    assert_equal("def", event.hooklys_identifier)
    assert_equal(DateTime.parse("2022-02-26 18:33:03 UTC"), event.details.first.timestamp)
    assert_equal(:info, event.details.first.level)
    assert_equal("Test message", event.details.first.message)
  end

  test "#add_detail" do
    travel_to("2022-02-26 18:33:03 UTC") do
      event = RuleEvent.new(shopify_identifier: 'abc', hooklys_identifier: 'def')
      event.add_detail(:info, "Test message 1")
      event.add_detail(:error, "Test message 2")

      assert_equal(DateTime.parse("2022-02-26 18:33:03 UTC"), event.details[0].timestamp)
      assert_equal(:info, event.details[0].level)
      assert_equal("Test message 1", event.details[0].message)

      assert_equal(DateTime.parse("2022-02-26 18:33:03 UTC"), event.details[1].timestamp)
      assert_equal(:error, event.details[1].level)
      assert_equal("Test message 2", event.details[1].message)
    end
  end

  test "#dump" do
    travel_to("2022-02-26 18:33:03 UTC") do
      event = RuleEvent.new(shopify_identifier: 'abc', hooklys_identifier: 'def')
      event.add_detail(:info, "Test message")
  
      expected = {
        "shopify_identifier" => "abc",
        "hooklys_identifier" => "def",
        "details" => [
          { "timestamp" => "2022-02-26 18:33:03", "level" => "info", "message" => "Test message" },
        ]
      }
      assert_equal(expected, event.dump)
    end
  end
end 
