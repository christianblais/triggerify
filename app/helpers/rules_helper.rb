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
end
