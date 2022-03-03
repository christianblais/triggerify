require 'test_helper'

class RuleEventDetailTest < ActiveSupport::TestCase
  test ".load" do
    attributes = {
      "timestamp" => "2022-02-26 18:33:03",
      "level" => "info",
      "message" => "Test message",
    }
    detail = RuleEventDetail.load(attributes)

    assert_equal(DateTime.parse("2022-02-26 18:33:03 UTC"), detail.timestamp)
    assert_equal(:info, detail.level)
    assert_equal("Test message", detail.message)
  end

  test "#new" do
    travel_to("2022-02-26 18:33:03 UTC") do
      detail = RuleEventDetail.new(level: :info, message: "Test message")

      assert_equal(DateTime.parse("2022-02-26 18:33:03 UTC"), detail.timestamp)
      assert_equal(:info, detail.level)
      assert_equal("Test message", detail.message)
    end
  end

  test "#dump" do
    travel_to("2022-02-26 18:33:03 UTC") do
      detail = RuleEventDetail.new(level: :info, message: "Test message")
  
      expected = {
        "timestamp" => "2022-02-26 18:33:03",
        "level" => "info",
        "message" => "Test message",
      }
      assert_equal(expected, detail.dump)
    end
  end
end 
