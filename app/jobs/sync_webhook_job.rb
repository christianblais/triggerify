class SyncWebhookJob < ShopJob
  def perform_with_shop(*_args)
    delete_extra_webhooks
    create_missing_webhooks
  end

  private

  def delete_extra_webhooks
    ShopifyAPI::Webhook.all.each do |webhook|
      unless desired_webhook?(webhook)
        webhook.destroy
      end
    end
  end

  def create_missing_webhooks
    existing_webhooks = ShopifyAPI::Webhook.all

    desired_topics.each do |topic|
      next if existing_webhooks.map(&:topic).include?(topic)

      ShopifyAPI::Webhook.create!(
        address: webhook_address,
        format: webhook_format,
        topic: topic,
      )
    end
  end

  def desired_webhook?(webhook)
    return false if desired_topics.exclude?(webhook.topic)
    return false if webhook.address != webhook_address
    return false if webhook.format != webhook_format

    true
  end

  def webhook_address
    Rails.configuration.webhook_callback_url
  end

  def webhook_format
    "json"
  end

  def desired_topics
    shop.rules.where(enabled: true).distinct(:topic).pluck(:topic).push('app/uninstalled')
  end
end
