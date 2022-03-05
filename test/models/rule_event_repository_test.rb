require 'test_helper'

class RuleEventRepositoryTest < ActiveSupport::TestCase
  setup do
    @repository = RuleEventRepository.new
  end

  test '.dump' do
    travel_to("2022-02-26 11:11:11 UTC") do
      event = RuleEvent.new(identifier: 'abc')
      event.add_detail(:info, "test 1")
      @repository.add_event(event)
    end
    travel_to("2022-02-26 22:22:22 UTC") do
      event = RuleEvent.new(identifier: 'xyz')
      event.add_detail(:error, "test 2")
      @repository.add_event(event)
    end

    expected = [
      { "identifier" => "abc", "details" => [{ "timestamp"=>"2022-02-26 11:11:11", "level"=>"info", "message"=>"test 1" }]},
      { "identifier" => "xyz", "details" => [{ "timestamp"=>"2022-02-26 22:22:22", "level"=>"error", "message"=>"test 2" }]}
    ]
    assert_equal(expected, RuleEventRepository.dump(@repository))
  end

  test '.load' do
    raw = [
      { "identifier" => "abc", "details" => [{ "timestamp"=>"2022-02-26 11:11:11", "level"=>"info", "message"=>"test 1" }]},
      { "identifier" => "xyz", "details" => [{ "timestamp"=>"2022-02-26 22:22:22", "level"=>"error", "message"=>"test 2" }]},
      { "details" => []}
    ]

    repository = RuleEventRepository.load(raw)

    assert_equal(3, repository.count)

    first_event = repository.to_a[0]
    assert_equal("abc", first_event.identifier)
    assert_equal(1, first_event.details.count)
    assert_equal(DateTime.parse("2022-02-26 11:11:11"), first_event.details[0].timestamp)
    assert_equal(:info, first_event.details[0].level)
    assert_equal("test 1", first_event.details[0].message)

    second_event = repository.to_a[1]
    assert_equal("xyz", second_event.identifier)
    assert_equal(1, second_event.details.count)
    assert_equal(DateTime.parse("2022-02-26 22:22:22"), second_event.details[0].timestamp)
    assert_equal(:error, second_event.details[0].level)
    assert_equal("test 2", second_event.details[0].message)

    # temporary backfill as not all events have an identifier?
    # todo: purge existing events, remove this feature?
    third_event = repository.to_a[2]
    assert_equal("", third_event.identifier)
    assert_equal(0, third_event.details.count)
  end

  test "#add_event" do
    travel_to("2022-02-26 18:33:03 UTC") do
      event = RuleEvent.new(identifier: "abc")
      event.add_detail(:info, "test")

      @repository.add_event(event)
    end
  
    collected_event = @repository.to_a.first

    assert_equal(DateTime.parse("2022-02-26T18:33:03.000Z"), collected_event.details.first.timestamp)
    assert_equal(:info, collected_event.details.first.level)
    assert_equal("test", collected_event.details.first.message)
  end

  test "#add_event kept a maximum of the last 10" do
    10.times do
      event = RuleEvent.new(identifier: 'abc')
      event.add_detail(:info, "test")
      @repository.add_event(event)
    end

    assert_equal(10, @repository.count)

    extra_event = RuleEvent.new(identifier: 'xyz')
    extra_event.add_detail(:info, "test extra")

    assert_difference(-> { @repository.count }, 0) do
      @repository.add_event(extra_event)
    end

    assert_equal(extra_event, @repository.to_a.last)
  end
end
