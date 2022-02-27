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
    event = RuleEvent.new
    event.add_detail(:info, "test persistence")

    assert_difference(-> { @rule.reload.events.count }, 1) do
      @rule.events.add_event(event)
      @rule.save!
    end

    assert_equal("test persistence", @rule.events.to_a.last.details.first.message)
  end

  test "#event serialization persist non-ruby objects" do
    travel_to("2022-02-26 18:33:03 UTC") do
      event = RuleEvent.new
      event.add_detail(:info, "test")
      @rule.events.add_event(event)
      @rule.save!
    end

    results = Rule.connection.select_all("SELECT events FROM rules where id = #{@rule.id}")
    expected = '[{"details":[{"timestamp":"2022-02-26 18:33:03","level":"info","message":"test"}]}]'
    assert_equal(expected, results.rows.first.first)
  end

  test "#event serialization without events" do
    rule = Rule.create!(
      name: 'Email on customer creation from Canada',
      shop: @shop,
      enabled: true,
      topic: 'customers/create',
    )

    results = Rule.connection.select_all("SELECT events FROM rules where id = #{rule.id}")
    expected = '[]'
    assert_equal(expected, results.rows.first.first)
  end
end
