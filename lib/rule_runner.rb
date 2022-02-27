class RuleRunner
  def initialize(rule:, callback:)
    @rule = rule
    @callback = callback
  end

  def perform
    rule_event.add_detail(:info, "Event received")

    rule.filters.each.with_index do |filter, index|
      valid = FilterValidator.new(filter).valid?(callback)
      
      if valid
        rule_event.add_detail(:info, "Filter ##{index + 1}: Met")
      else
        rule_event.add_detail(:info, "Filter ##{index + 1}: Unmet, event dropped")

        save_rule_event!
        return
      end
    end

    rule.handlers.each.with_index do |handler, index|
      handle(handler, index)
    end

    save_rule_event!
  end

  private

  attr_reader :rule, :callback

  def rule_event
    @rule_event ||= RuleEvent.new
  end

  def handle(handler, index)
    handler.handle(callback)

    rule_event.add_detail(:info, "Handler ##{index + 1}: Successful")
  rescue Handlers::UserError => e
    Rails.logger.info("User error: #{e.message}")

    rule_event.add_detail(:error, "Handler ##{index + 1}: #{e.message}")
  rescue StandardError
    rule_event.add_detail(:error, "Handler ##{index + 1}: Server error")

    save_rule_event!

    raise
  end

  def save_rule_event!
    rule.events = rule.events.push(rule_event)
    rule.save!
  end
end
