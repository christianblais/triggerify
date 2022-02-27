require 'test_helper'

class RuleEventsSerializerTest < ActiveSupport::TestCase
  test '.dump' do
    events = []
    travel_to("2022-02-26 11:11:11 UTC") do
      event = RuleEvent.new
      event.add_detail(:info, "test 1")
      events << event
    end
    travel_to("2022-02-26 22:22:22 UTC") do
      event = RuleEvent.new
      event.add_detail(:error, "test 2")
      events << event
    end

    expected = "[" + \
      "{\"timestamp\":\"2022-02-26 11:11:11\",\"details\":[{\"level\":\"info\",\"message\":\"test 1\"}]}," + \
      "{\"timestamp\":\"2022-02-26 22:22:22\",\"details\":[{\"level\":\"error\",\"message\":\"test 2\"}]}" + \
      "]"
    assert_equal(expected, RuleEventsSerializer.dump(events))
  end

  test '.load' do
    string = "[" + \
      "{\"timestamp\":\"2022-02-26 11:11:11\",\"details\":[{\"level\":\"info\",\"message\":\"test 1\"}]}," + \
      "{\"timestamp\":\"2022-02-26 22:22:22\",\"details\":[{\"level\":\"error\",\"message\":\"test 2\"}]}" + \
      "]"

    events = RuleEventsSerializer.load(string)

    assert_equal(2, events.length)

    assert_equal(DateTime.parse("2022-02-26 11:11:11"), events[0].timestamp)
    assert_equal(1, events[0].details.length)
    assert_equal(:info, events[0].details[0].level)
    assert_equal("test 1", events[0].details[0].message)

    assert_equal(DateTime.parse("2022-02-26 22:22:22"), events[1].timestamp)
    assert_equal(1, events[1].details.length)
    assert_equal(:error, events[1].details[0].level)
    assert_equal("test 2", events[1].details[0].message)
  end
end
