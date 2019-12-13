class SyncWebhookJob < ShopJob
  def perform_with_shop(*_args)
    delete_extra_webhooks
    create_missing_webhooks
  end

  private

  def delete_extra_webhooks
    ShopifyAPI::Webhook.all.each do |webhook|
      if desired_topics.exclude?(webhook.topic) || webhook.address != callback_path
        webhook.destroy
      end
    end
  end

  def create_missing_webhooks
    existing_webhooks = ShopifyAPI::Webhook.all

    desired_topics.each do |topic|
      next if existing_webhooks.map(&:topic).include?(topic)

      ShopifyAPI::Webhook.create(
        address: callback_path,
        format: 'json',
        topic: topic,
      )
    end
  end

  def callback_path
    ENV.fetch('WEBHOOK_CALLBACK_URL')
  end

  def desired_topics
    shop.rules.all.distinct(:topic).pluck(:topic).push('app/uninstalled')
  end
end
