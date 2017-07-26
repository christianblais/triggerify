module Handlers
  class DatadogEvent < Base
    description %(
      Use the Datadog API to send custom events.
      <a href="https://www.datadoghq.com/" target="_blank">Click here</a>
      for more information.
    )

    setting :api_key,
      name: 'Datadog API key'

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
