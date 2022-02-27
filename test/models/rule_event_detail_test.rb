require 'test_helper'

class RuleEventDetailTest < ActiveSupport::TestCase
  test ".load" do
    attributes = {
      "level" => "info",
      "message" => "Test message",
    }
    detail = RuleEventDetail.load(attributes)

    assert_equal(:info, detail.level)
    assert_equal("Test message", detail.message)
  end

  test "#new" do
    detail = RuleEventDetail.new(level: :info, message: "Test message")

    assert_equal(:info, detail.level)
    assert_equal("Test message", detail.message)
  end

  test "#dump" do
    detail = RuleEventDetail.new(level: :info, message: "Test message")

    expected = {
      "level" => "info",
      "message" => "Test message",
    }
    assert_equal(expected, detail.dump)
  end
end 
