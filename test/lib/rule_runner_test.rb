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

    assert_difference(-> { @rule.reload.events.count }, 1) do
      travel_to("2022-02-26 18:33:03 UTC") do
        @runner.perform
      end
    end

    expected = {
      "details" => [
        { "timestamp"=>"2022-02-26 18:33:03", "level" => "info", "message" => "Event received" },
        { "timestamp"=>"2022-02-26 18:33:03", "level" => "info", "message" => "Filter #1: Met" },
        { "timestamp"=>"2022-02-26 18:33:03", "level" => "info", "message" => "Handler #1: Successful" }
      ]
    }
    assert_equal(expected, @rule.reload.events.to_a.last.dump)
  end

  test '#perform with unmet filter stops the chain' do
    Handlers::Emailer.any_instance.expects(:call).never

    runner = RuleRunner.new(
      rule: @rule,
      callback: {
        "id" => "1234",
        "country" => "Not-Canada",
      }
    )

    assert_difference(-> { @rule.reload.events.count }, 1) do
      travel_to("2022-02-26 18:33:03 UTC") do
        runner.perform
      end
    end

    expected = {
      "details" => [
        { "timestamp"=>"2022-02-26 18:33:03", "level" => "info", "message" => "Event received" },
        { "timestamp"=>"2022-02-26 18:33:03", "level" => "info", "message" => "Filter #1: Unmet" },
        { "timestamp"=>"2022-02-26 18:33:03", "level" => "info", "message" => "A filter was unmet, dropping event" }
      ]
    }
    assert_equal(expected, @rule.reload.events.to_a.last.dump)
  end

  test '#perform on handler user error writes a rule event' do
    Handlers::Emailer
      .any_instance
      .expects(:call)
      .raises(Handlers::UserError, "Something wrong with Twillio")

    assert_difference(-> { @rule.reload.events.count }, 1) do
      travel_to("2022-02-26 18:33:03 UTC") do
        @runner.perform
      end
    end

    expected = {
      "details" => [
        { "timestamp"=>"2022-02-26 18:33:03", "level" => "info", "message" => "Event received" },
        { "timestamp"=>"2022-02-26 18:33:03", "level" => "info", "message" => "Filter #1: Met" },
        { "timestamp"=>"2022-02-26 18:33:03", "level" => "error", "message" => "Handler #1: Something wrong with Twillio" }
      ],
    }
    assert_equal(expected, @rule.reload.events.to_a.last.dump)
  end

  test '#perform on server error writes a rule event' do
    Handlers::Emailer
      .any_instance
      .expects(:call)
      .raises(StandardError, "Some ruby unexpected behaviour")

    assert_difference(-> { @rule.reload.events.count }, 1) do
      travel_to("2022-02-26 18:33:03 UTC") do
        assert_raises(StandardError) do
          @runner.perform
        end
      end
    end

    expected = {
      "details" => [
        { "timestamp"=>"2022-02-26 18:33:03", "level" => "info", "message" => "Event received" },
        { "timestamp"=>"2022-02-26 18:33:03", "level" => "info", "message" => "Filter #1: Met" },
        { "timestamp"=>"2022-02-26 18:33:03", "level" => "error", "message" => "Server error" }
      ],
    }
    assert_equal(expected, @rule.reload.events.to_a.last.dump)
  end
end
