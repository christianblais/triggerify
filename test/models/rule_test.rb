require 'test_helper'

class RuleTest < ActiveSupport::TestCase
  setup do
    @shop = shops(:regular_shop)
    @rule = rules(:email)
  end

  test "create" do
    Rule.create!(
      name: 'Email on customer creation from Canada',
      shop: @shop,
      enabled: true,
      topic: 'customers/create',
    )
  end

  test "#events are persisted" do
    assert_difference(-> { @rule.reload.events.length }, 1) do
      travel_to("2022-02-26 18:33:03 UTC") do
        event = RuleEvent.new
        event.add_detail(:info, "test")

        @rule.events = @rule.events.push(event)
        @rule.save!
      end
    end

    expected = DateTime.parse("2022-02-26T18:33:03.000Z")
    assert_equal(expected, @rule.events.last.timestamp)
  end

  test "#events are persisted to a maximum of the last 10" do
    10.times do
      event = RuleEvent.new
      event.add_detail(:info, "test")
      @rule.events = @rule.events.push(event)
    end
    @rule.save!

    assert_difference(-> { @rule.reload.events.length }, 0) do
      travel_to("2022-02-26 18:33:03 UTC") do
        event = RuleEvent.new
        event.add_detail(:info, "test")

        @rule.events = @rule.events.push(event)
        @rule.save!
      end
    end

    expected = DateTime.parse("2022-02-26T18:33:03.000Z")
    assert_equal(expected, @rule.events.last.timestamp)
  end

  test "#event serialization persist non-ruby objects" do
    travel_to("2022-02-26 18:33:03 UTC") do
      event = RuleEvent.new
      event.add_detail(:info, "test")
      @rule.events = @rule.events.push(event)
      @rule.save!
    end

    results = Rule.connection.select_all("SELECT events FROM rules")
    expected = "[{\"timestamp\":\"2022-02-26 18:33:03\",\"details\":[{\"level\":\"info\",\"message\":\"test\"}]}]"
    assert_equal(expected, results.rows.first.first)
  end
end
