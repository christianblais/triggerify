module Handlers
  class DatadogEvent < Base
    label 'Send a Datadog event'

    description %(
      Use the Datadog API to send custom events.
      <a href="https://github.com/christianblais/triggerify/wiki/Rule-Action-Datadog-Event" target="_blank">More information</a>
    )

    setting :api_key,
      name: 'Datadog API key',
      example: '4e72a1937a2cxxxxxxxxxxxxxxxxxxxx'

    setting :metric_name,
      name: 'Event name',
      example: 'order.create'

    setting :alert_type,
      options: %w(info success warning error),
      name: 'Alert type',
      example: 'info'

    setting :priority,
      options: %w(normal low),
      name: 'Priority',
      example: 'normal'

    def call
      return if [
        api_key,
        metric_name
      ].any?(&:blank?)

      dog = ::Dogapi::Client.new(api_key)
      msg = ::Dogapi::Event.new(metric_name, @settings.except(:api_key, :metric_name))
      dog.emit_event(msg)
    end
  end
end
