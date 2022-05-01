class RuleRunner
  def initialize(rule:, callback:, shopify_identifier:, hooklys_identifier:)
    @rule = rule
    @callback = callback
    @shopify_identifier = shopify_identifier
    @hooklys_identifier = hooklys_identifier
  end

  def perform
    rule_event.add_detail(:info, "Event received")

    filters_valid = true
    rule.filters.order(:id).each.with_index do |filter, index|
      if FilterValidator.new(filter).valid?(callback)
        rule_event.add_detail(:info, "Filter ##{index + 1}: Met")
      else
        rule_event.add_detail(:info, "Filter ##{index + 1}: Unmet")
        filters_valid = false
      end
    end

    unless filters_valid
      rule_event.add_detail(:info, "A filter was unmet, dropping event")
      return
    end

    rule.handlers.order(:id).each.with_index do |handler, index|
      handle(handler, index)
    end
  rescue StandardError
    rule_event.add_detail(:error, "An unhandled exception happenend on our server. Our engineers have been notified.")

    raise
  ensure
    save_rule_event!
  end

  private

  attr_reader :rule, :callback, :shopify_identifier, :hooklys_identifier

  def rule_event
    @rule_event ||= RuleEvent.new(
      shopify_identifier: shopify_identifier,
      hooklys_identifier: hooklys_identifier,
    )
  end

  def handle(handler, index)
    handler.handle(callback)

    rule_event.add_detail(:info, "Handler ##{index + 1}: Successful")
  rescue Handlers::UserError => e
    Rails.logger.info("User error: #{e.message}")

    rule_event.add_detail(:error, "Handler ##{index + 1}: #{e.message}")
  end

  def save_rule_event!
    rule.events.add_event(rule_event)
    rule.save!(validate: false)
  end
end
