require 'test_helper'

module Handlers
  class DatadogEventTest < ActiveSupport::TestCase
    test '#call' do
      handler = build_handler

      mock_datadog_client = mock
      ::Dogapi::Client
        .expects(:new)
        .with("test_api_key")
        .returns(mock_datadog_client)

      mock_datadog_event = mock
      ::Dogapi::Event
        .expects(:new)
        .with("test.metric.name", { alert_type: "info", priority: "normal" })
        .returns(mock_datadog_event)

      mock_datadog_client
        .expects(:emit_event)
        .with(mock_datadog_event)

      handler.call
    end

    test '#call with missing api_key' do
      handler = build_handler(api_key: "")

      e = assert_raises(UserError) do
        handler.call
      end
      assert_equal e.message, "Missing 'api_key'"
    end

    test '#call with missing metric_name' do
      handler = build_handler(metric_name: "")

      e = assert_raises(UserError) do
        handler.call
      end
      assert_equal e.message, "Missing 'metric_name'"
    end

    private

    def build_handler(api_key: "test_api_key", metric_name: "test.metric.name", alert_type: "info", priority: "normal")
      settings = {
        api_key: api_key,
        metric_name: metric_name,
        alert_type: alert_type,
        priority: priority,
      }

      shop = shops(:regular_shop)
      DatadogEvent.new(shop, settings, {})
    end
  end
end
