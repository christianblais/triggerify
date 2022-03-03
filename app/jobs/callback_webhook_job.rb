class CallbackWebhookJob < ShopJob
  def perform_with_shop(topic:, callback:)
    rules = shop.rules.enabled.where(topic: topic)

    rules.each do |rule|
      process_rule(rule, callback)
    end
  end

  private

  def process_rule(rule, callback)
    RuleRunner.new(
      rule: rule,
      callback: callback
    ).perform
  rescue StandardError => e
    report_exception(e) do |report|
      report.add_tab(:rule, {
        rule_id: rule.id,
        shopify_domain: shop.shopify_domain,
      })
    end
  end
end
