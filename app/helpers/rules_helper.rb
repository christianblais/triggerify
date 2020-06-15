module RulesHelper
  def payload_to_values(payload)
    flatten_payload_values(payload).map do |key, value|
      [key, "{{ #{key} }}", { data: { type: value.to_s } }]
    end
  end

  def flatten_payload_values(payload, prefix = nil)
    if payload.is_a?(Hash)
      payload.map do |key, value|
        next if value.is_a?(Array)

        if prefix
          flatten_payload_values(value, "#{prefix}.#{key}")
        else
          flatten_payload_values(value, key)
        end
      end.compact.reduce(&:merge)
    else
      { prefix => payload }
    end
  end

  def available_handlers
    current_shop_handlers = shop.rules.joins(:handlers).select('handlers.service_name').distinct

    Handler::HANDLERS.reject do |handler|
      handler.deprecated? && current_shop_handlers.exclude?(handler.to_s)
    end
  end
end
