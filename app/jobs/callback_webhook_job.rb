class CallbackWebhookJob < ShopJob
  def perform_with_shop(topic:, callback:)
    shop.rules.where(topic: topic).includes(:filters, :handlers).each do |rule|
      next unless rule.filters.all? do |filter|
        FilterValidator.new(filter).valid?(callback)
      end

      rule.handlers.each do |handler|
        begin
          handler.handle(callback)
        rescue StandardError => exception
          Rails.logger.info("ERROR with #{handler.class.name}")
          Rails.logger.info(" -- #{exception}")
          Rails.logger.info(" -- #{exception.message}")

          Bugsnag.notify(exception)
        end
      end
    end
  end
end
