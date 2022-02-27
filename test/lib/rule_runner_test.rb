require 'test_helper'

class RuleRunnerTest < ActiveSupport::TestCase
  setup do
    @rule = rules(:email)
    @runner = RuleRunner.new(
      rule: @rule,
      callback: {
        "id" => "1234",
        "email" => "test@example.com",
        "country" => "Canada",
      }
    )
  end

  test '#perform' do
    Handlers::Emailer.any_instance.expects(:call)

    @runner.perform
  end

  test '#perform writes a rule event' do
    Handlers::Emailer.any_instance.expects(:call)

    assert_difference(-> { @rule.reload.events.length }, 1) do
      travel_to("2022-02-26 18:33:03 UTC") do
        @runner.perform
      end
    end

    expected = {
      "timestamp"=>"2022-02-26 18:33:03",
      "details" => [
        { "level" => "info", "message" => "Event received" },
        { "level" => "info", "message" => "Filter #1: Met" },
        { "level" => "info", "message" => "Handler #1: Successful" }
      ]
    }
    assert_equal(expected, @rule.events.last.dump)
  end

  test '#perform on user error writes a rule event' do
    Handlers::Emailer
      .any_instance
      .expects(:call)
      .raises(Handlers::UserError, "Something wrong with Twillio")

    assert_difference(-> { @rule.reload.events.length }, 1) do
      travel_to("2022-02-26 18:33:03 UTC") do
        @runner.perform
      end
    end

    expected = {
      "timestamp"=>"2022-02-26 18:33:03",
      "details" => [
        { "level" => "info", "message" => "Event received" },
        { "level" => "info", "message" => "Filter #1: Met" },
        { "level" => "error", "message" => "Handler #1: Something wrong with Twillio" }
      ],
    }
    assert_equal(expected, @rule.events.last.dump)
  end

  test '#perform on server error writes a rule event' do
    Handlers::Emailer
      .any_instance
      .expects(:call)
      .raises(StandardError, "Some ruby unexpected behaviour")

    assert_difference(-> { @rule.reload.events.length }, 1) do
      travel_to("2022-02-26 18:33:03 UTC") do
        assert_raises(StandardError) do
          @runner.perform
        end
      end
    end

    expected = {
      "timestamp"=>"2022-02-26 18:33:03",
      "details" => [
        { "level" => "info", "message" => "Event received" },
        { "level" => "info", "message" => "Filter #1: Met" },
        { "level" => "error", "message" => "Handler #1: Server error" }
      ],
    }
    assert_equal(expected, @rule.events.last.dump)
  end
end
