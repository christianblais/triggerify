class CallbackWebhookJob < ShopJob
  def perform_with_shop(topic:, callback:)
    rules = shop.rules.where(topic: topic).includes(:filters, :handlers)

    rules.each do |rule|
      process_rule(rule, callback)
    end
  end

  private

  def process_rule(rule, callback)
    return unless rule.filters.all? do |filter|
      FilterValidator.new(filter).valid?(callback)
    end

    rule.handlers.each do |handler|
      handler.handle(callback)
    end
  rescue StandardError => e
    report_exception(e) do |report|
      report.add_tab(:rule, {
        rule_id: rule.id
      })
    end
  end
end
