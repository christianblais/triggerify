class CallbackWebhookJob < ShopJob
  def perform_with_shop(topic:, callback:)
    shop.rules.where(topic: topic).each do |rule|
      rule.handlers.each do |handler|
        handler.handle(callback)
      end
    end
  end
end
